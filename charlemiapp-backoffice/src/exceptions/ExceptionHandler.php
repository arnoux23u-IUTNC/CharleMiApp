<?php

namespace charlemiapp\exceptions;

use Exception;
use Slim\Container;
use Slim\Http\{Request, Response};

class ExceptionHandler
{

    private static Container $container;

    public function __construct(Container $container)
    {
        self::$container = $container;
    }

    public function __invoke(Request $request, Response $response, Exception $exception): Response
    {
        if ($exception instanceof ForbiddenException) {
            $title = $exception->getTitle();
            $msg = $exception->getMessage();
            $backRoute = $request->getHeader("HTTP_REFERER")[0] ?? self::$container['router']->pathFor("home");
            return $response->write(genererHeader($title, ["style.css"]) . "\t<div class='container_error'>\n\t\t<img alt='forbidden' class='forbidden' src='/assets/img/forbidden.png'>\n\t\t<h4>$msg</h4>\n\t\t<span><a id='backBtn' content='Retour' href='$backRoute'></a></span>\n\t</div>\n</body>\n</html>")->withStatus(403);
        }
        return $response->withStatus(500)->withHeader('Content-Type', 'text/html')->write($exception->getMessage());
    }
}