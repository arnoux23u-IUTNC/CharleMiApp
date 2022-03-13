<?php

namespace charlemiapp\views;

use JetBrains\PhpStorm\Pure;
use Slim\Container;
use Slim\Http\Request;

class UsersView
{

    private Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    #[Pure] public function render(Request $request): string
    {
        $popup = match ($request->getQueryParam('error', '')) {
            'notfound' => '<h4 style="font-family: \'Montserrat\', sans-serif; color:red;">User not found</h4>',
            default => '',
        };
        $html = <<<HTML
            <div class="container">
                $popup
                <form method="GET" action="{$this->container["router"]->pathFor('users')}">
                    <input type="text" name="id" placeholder="N° carte étudiant" required/>
                    <input type="submit" value="Rechercher" />
                </form>
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <a href="{$this->container['router']->pathFor('home')}">
                    <button class="stocks">Gestion des commandes</button>
                </a>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
                </a>
            </div>
        </body>
        </html>
        HTML;
        return genererHeader("Gestion des utilisateurs - CharleMi'App", ["home.css", "flex.css"]) . $html;
    }

    #[Pure] public function renderUser(Request $request, array $user): string
    {
        $bourseDom = $this->buildDomBourse($request->getQueryParam("id", ""), $user['boursier'] ?? false);
        $c_etu = $user['carte_etudiant'] ?? "Inconnue";
        $html = <<<HTML
            <div class="container">
                <h1>{$user['lastname']} {$user['firstname']}</h1>
                <p>Carte etudiant : $c_etu</p>
                $bourseDom
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <a href="{$this->container['router']->pathFor('home')}">
                    <button class="stocks">Gestion des commandes</button>
                </a>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
                </a>
            </div>
        </body>
        </html>
        HTML;
        return genererHeader("Gestion des utilisateurs - CharleMi'App", ["home.css", "flex.css"]) . $html;
    }

    private function buildDomBourse(string $id, bool $boursier): string
    {
        $bool = !$boursier;
        $p = "<p>Etudiant boursier : " . ($boursier ? "Oui" : "Non") . "</p>";
        $data = $boursier ? "Definir comme non boursier" : "Definir comme boursier";
        return <<<HTML
        $p
                <form action="{$this->container["router"]->pathFor('users')}" method="POST">
                    <input type="hidden" name="action" value="$bool" />
                    <input type="hidden" name="user_id" value="$id" />
                    <input type="submit" value="$data" />
                </form>
        HTML;
    }

}