<?php

namespace charlemiapp\views;

use JetBrains\PhpStorm\Pure;
use Slim\Container;

class LoginView
{

    private Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    #[Pure] public function render(array $data = []): string
    {
        $error = $data['error'] ?? '';
        return genererHeader("Login - CharleMi'App") . <<<HTML
            <form action="{$this->container['router']->pathFor('login')}" method="post">
                <div class="container">
                    $error
                    <label for="uname"><b>Email</b></label>
                    <input type="email" value="arnouxguillaume54@hotmail.fr" placeholder="Enter Email" name="email" required>
                    <label for="psw"><b>Password</b></label>
                    <input type="password" placeholder="Enter Password" value="guillaume" name="password" required>
                    <button type="submit">Login</button>
                </div>
            </form>       
        </body>
        </html>
        HTML;
    }

}