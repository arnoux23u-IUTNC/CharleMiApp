<?php
session_start();

require __DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'vendor' . DIRECTORY_SEPARATOR . 'autoload.php';

use charlemiapp\exceptions\ExceptionHandler;
use charlemiapp\OfficeController;
use Slim\{App, Container};
use Slim\Http\{Request, Response};
use Kreait\Firebase\Factory;

$container = new Container();
$container['settings']['displayErrorDetails'] = true;
$container['firebase'] = (new Factory)->withServiceAccount(__DIR__ . DIRECTORY_SEPARATOR . '..' . DIRECTORY_SEPARATOR . 'charlemi-app-b053ffa81bac.json');
$container['firebase_auth'] = $container['firebase']->createAuth();
$container['firebase_messaging'] = $container['firebase']->createMessaging();
$container['firestore'] = $container['firebase']->createFirestore()->database();
$container['notFoundHandler'] = function () {
    return function ($request, $response) {
        $html = file_get_contents('..' . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR . 'errors' . DIRECTORY_SEPARATOR . '404.html');
        return $response->withStatus(404)->write($html);
    };
};
$container['notAllowedHandler'] = function () {
    return function ($request, $response) {
        $html = file_get_contents('..' . DIRECTORY_SEPARATOR . 'src' . DIRECTORY_SEPARATOR . 'errors' . DIRECTORY_SEPARATOR . '405.html');
        return $response->withStatus(405)->write($html);
    };
};
$container['errorHandler'] = function () use ($container) {
    return new ExceptionHandler($container);
};
$app = new App($container);

$app->any('/users[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->users($request, $response, $args);
})->setName('users');
$app->any('/edit-product/{id}[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->editProduct($request, $response, $args);
})->setName('editProduct');
$app->any('/remove-product/{id}[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->deleteProduct($request, $response, $args);
})->setName('deleteProduct');
$app->any('/add-product[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->addProduct($request, $response, $args);
})->setName('addProduct');
$app->any('/stocks[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->stocks($request, $response, $args);
})->setName('stocks');
$app->post('/change-card-data[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->changeOrderData($request, $response, $args);
});
$app->post('/change-opening[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->changeOpening($request, $response, $args);
})->setName('openSet');
$app->get('/logout[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->logout($request, $response, $args);
})->setName('logout');
$app->any('/login[/]', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->login($request, $response, $args);
})->setName('login');
$app->get('/', function (Request $request, Response $response, array $args) {
    return (new OfficeController($this))->home($request, $response, $args);
})->setName('home');

try {
    $app->run();
} catch (Throwable $e) {
    header($_SERVER["SERVER_PROTOCOL"] . ' 500 Internal Server Error', true, 500);
    echo '<h1>Something went wrong!</h1>';
    print_r($e);
    exit;
}

function genererHeader(string $title, array $styles = []): string
{
    $html = <<<EOD
    <!DOCTYPE html>
    <html lang="fr">
    <head>
        <meta charset='UTF-8'>
        <link rel="icon" href="/assets/img/icons/favicon.png">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
        <link href='https://unpkg.com/boxicons@2.1.1/css/boxicons.min.css' rel='stylesheet'>
        <link href="https://fonts.googleapis.com/css?family=Poiret+One" rel="stylesheet">
        <link rel="stylesheet" href="/assets/css/global.css"/>
        <title>$title</title>
    EOD;
    foreach ($styles as $style)
        $html .= "\n\t<link rel='stylesheet' href='/assets/css/$style'>";
    $html .= "\n</head>\n<body>\n";
    return $html;
}