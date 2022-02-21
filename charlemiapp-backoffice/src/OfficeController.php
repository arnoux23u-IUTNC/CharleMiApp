<?php /** @noinspection PhpUnhandledExceptionInspection */

namespace charlemiapp;

use charlemiapp\views\{HomeView, LoginView};
use Kreait\Firebase\Exception\Auth\EmailNotFound;
use Kreait\Firebase\Exception\Auth\InvalidCustomToken;
use Kreait\Firebase\Exception\Auth\UserNotFound;
use Lcobucci\JWT\Exception;
use Slim\Container;
use Slim\Http\{Request, Response};
use Slim\Exception\MethodNotAllowedException;

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
        /*$pendingOrders = $orders->where('status', '==', 'PENDING')->documents();
        $waitingOrders = $orders->where('status', '==', 'WAITING')->documents();
        $readyOrders = $orders->where('status', '==', 'READY')->documents();
        $finishedOrders = $orders->where('status', '==', 'FINISHED')->documents();
        $canceledOrders = $orders->where('status', '==', 'CANCELED')->documents();*/
        return $response->write($view->render($orders));
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
                        } catch (InvalidCustomToken | \InvalidArgumentException) {
                            return $response->write($view->render(['error' => 'Invalid token.']));
                        }
                    } catch (\Exception) {
                        $_SESSION = [];
                        session_regenerate_id(true);
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

}