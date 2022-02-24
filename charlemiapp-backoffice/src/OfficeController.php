<?php /** @noinspection PhpUnhandledExceptionInspection */

namespace charlemiapp;

use Slim\Container;
use Slim\Http\{Request, Response};
use charlemiapp\views\{HomeView, LoginView, StocksView};
use Slim\Exception\MethodNotAllowedException;
use Kreait\Firebase\Exception\Auth\UserNotFound;
use Kreait\Firebase\Exception\Auth\InvalidCustomToken;

class OfficeController
{

    private Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    public function home(Request $request, Response $response, array $args): Response
    {
        $view = new HomeView($this->container);
        if (empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('login'));
        $ordersSnapshot = $this->container['firestore']->collection('orders')->where('timestamp', '>', date('Y-m-d'))->documents();
        if ($ordersSnapshot->isEmpty())
            return $response->write($view->noOrders());
        $orders = [];
        foreach ($ordersSnapshot as $order) {
            $orderData = $order->data();
            $orders[$orderData["status"] ?? "ABANDONED"][$order->id()] = $order->data();
        }
        $is_open = $this->container['firestore']->collection('global_data')->document('charlemiam')->snapshot()->data()['is_open'] ?? false;
        return $response->write($view->render($orders, $is_open));
    }

    public function login(Request $request, Response $response, array $args): Response
    {
        if (!empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('home'));
        $view = new LoginView($this->container);
        switch ($request->getMethod()) {
            case 'GET':
                return $response->write($view->render());
            case 'POST':
                $data = $request->getParsedBody();
                if (empty($data['email']) || empty($data['password'])) {
                    return $response->write($view->render(['error' => 'Please fill in all fields.']));
                }
                try {
                    $this->container['firebase_auth']->getUserByEmail($data['email']);
                    try {
                        $result = $this->container['firebase_auth']->signInWithEmailAndPassword($data['email'], $data['password']);
                        $token = $result->idToken();
                        try {
                            $verifiedToken = $this->container['firebase_auth']->verifyIdToken($token);
                            $user = $verifiedToken->claims()->get('sub');
                            $_SESSION['USER_UID'] = $user;
                            $_SESSION['SESSION_UUID'] = $token;
                            return $response->withRedirect($this->container['router']->pathFor('home'));
                        } catch (InvalidCustomToken|\InvalidArgumentException) {
                            return $response->write($view->render(['error' => 'Invalid token.']));
                        }
                    } catch (\Exception) {
                        return $response->write($view->render(['error' => 'Wrong password or bad computer clock sync.']));
                    }
                } catch (UserNotFound) {
                    return $response->write($view->render(['error' => 'User not found.']));
                }
            default:
                throw new MethodNotAllowedException($request, $response, ['GET', 'POST']);
        }
    }

    public function profile(Request $request, Response $response, array $args): Response
    {
        if (empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('login'));
        foreach ($_SESSION as $key => $value) {
            print_r($key . ': ' . $value . '<br>');
        }
        return $response->write('Profile<br>');
    }

    public function logout(Request $request, Response $response, array $args): Response
    {
        session_destroy();
        return $response->withRedirect($this->container['router']->pathFor('login'));
    }

    public function changeOpening(Request $request, Response $response, array $args): Response
    {
        if (empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('login'));
        $need_open = $request->getParsedBody()['open'] === "open";
        $this->container['firestore']->collection('global_data')->document('charlemiam')->update([
            ['path' => 'is_open', 'value' => $need_open]
        ]);
        return $response->withRedirect($this->container['router']->pathFor('home'));
    }

    public function changeOrderData(Request $request, Response $response, array $args): Response
    {
        if (empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('login'));
        $data = $request->getParsedBody();
        $order_id = $data['cardId'];
        $order_status = $data['columnId'];
        $this->container['firestore']->collection('orders')->document($order_id)->update([
            ['path' => 'status', 'value' => $order_status]
        ]);
        return $response->write(json_encode($request->getParsedBody()));
    }

    public function stocks(Request $request, Response $response, array $args): Response
    {
        if (empty($_SESSION['USER_UID']))
            return $response->withRedirect($this->container['router']->pathFor('login'));
        switch ($request->getMethod()) {
            case 'GET':
                $view = new StocksView($this->container);
                $products = [];
                foreach ($this->container['firestore']->collection('products')->documents() as $product) {
                    $products[] = $product->data();
                }
                return $response->write($view->render($products));
            case 'POST':
                $data = $request->getParsedBody();
                $this->container['firestore']->collection('products')->document($data['id'])->update([
                    ['path' => 'stock', 'value' => $data['stock']]
                ]);
                return $response->withRedirect($this->container['router']->pathFor('stocks'));
            default:
                throw new MethodNotAllowedException($request, $response, ['GET', 'POST']);
        }
    }

    public function addProduct(Request $request, Response $response, array $args): Response
    {
        switch ($request->getMethod()) {
            case 'GET':
                $view = new StocksView($this->container);
                //category attribute is stored in document product
                $categories = [];
                foreach ($this->container['firestore']->collection('products')->documents() as $category) {
                    $categName = $category->data()['category'] ?? '';
                    if (!in_array($categName, $categories))
                        $categories[] = $categName;
                }
                return $response->write($view->renderAddProduct($categories));
            case 'POST':
                $data = $request->getParsedBody();
                $id = sprintf("P%04d", $this->getNextProductId());
                $this->container['firestore']->collection('products')->document($id)->set([
                    'id' => $id,
                    'name' => $data['name'],
                    'category' => $data['category'],
                    'price' => $data['price'],
                    'stock' => 0
                ]);
                return $response->withRedirect($this->container['router']->pathFor('stocks'));
            default:
                throw new MethodNotAllowedException($request, $response, ['GET', 'POST']);
        }
    }

    public function editProduct(Request $request, Response $response, array $args): Response
    {
        switch ($request->getMethod()) {
            case 'GET':
                $view = new StocksView($this->container);
                //category attribute is stored in document product
                $categories = [];
                foreach ($this->container['firestore']->collection('products')->documents() as $category) {
                    $categName = $category->data()['category'] ?? '';
                    if (!in_array($categName, $categories))
                        $categories[] = $categName;
                }
                $product = $this->container['firestore']->collection('products')->document($args['id']);
                return $response->write($view->renderEditProduct($product->snapshot()->data(), $categories));
            case 'POST':
                $data = $request->getParsedBody();
                $this->container['firestore']->collection('products')->document($data['id'])->set([
                    'id' => $data['id'],
                    'name' => $data['name'],
                    'category' => $data['category'],
                    'price' => $data['price'],
                    'stock' => 0
                ]);
                return $response->withRedirect($this->container['router']->pathFor('stocks'));
            default:
                throw new MethodNotAllowedException($request, $response, ['GET', 'POST']);
        }
    }

    public function deleteProduct(Request $request, Response $response, array $args): Response
    {
        switch ($request->getMethod()) {
            case 'GET':
                $this->container['firestore']->collection('products')->document($args['id'])->delete();
                return $response->withRedirect($this->container['router']->pathFor('stocks'));
            default:
                throw new MethodNotAllowedException($request, $response, ['GET', 'POST']);
        }
    }

    private function getNextProductId()
    {
        $products = $this->container['firestore']->collection('products')->documents();
        $id = 0;
        foreach ($products as $product) {
            $id = max($id, intval(substr($product->id(), 1)));
        }
        return $id + 1;
    }

}