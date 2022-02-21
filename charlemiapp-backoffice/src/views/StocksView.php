<?php

namespace charlemiapp\views;

use JetBrains\PhpStorm\Pure;
use Slim\Container;

class StocksView
{

    private Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    #[Pure] public function render(array $products): string
    {
        $domProducts = $this->buildDomProducts($products);
        $html = <<<HTML
            <div class="products">
        $domProducts
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <form action="{$this->container['router']->pathFor('openSet')}" method="POST">
                </form>
                <a href="{$this->container['router']->pathFor('home')}">
                    <button class="stocks">Gestion des commandes</button>
                </a>
                <a href="{$this->container['router']->pathFor('addProduct')}">
                    <button class="openclose open">Ajouter un produit</button>
                </a>
                <a href="{$this->container['router']->pathFor('removeProduct')}">
                    <button class="openclose close">Supprimer produit</button>
                </a>
            </div>
            <script src="/assets/js/draganddrop.js"></script>
            <script src="/assets/js/xhr-open.js"></script>
        </body>
        </html>
        HTML;
        return genererHeader("Gestion des stocks - CharleMi'App", ["home.css","stocks.css"]) . $html;
    }

    private function buildDomProducts(array $products): string
    {
        $domProducts = '';
        foreach ($products as $product) {
            $classStock = $product['stock'] > 0 ? 'in-stock' : 'out-of-stock';
            $domProducts .= <<<HTML
                    <div class="product" id="{$product['id']}">
                        <div class="product-name">{$product['name']}</div>
                        <form method="POST" action="#">
                            <label class="$classStock" for="datastock">Stock :</label>
                            <input name="id" type="hidden" required value="{$product['id']}" >
                            <input id="datastock" name="stock" type="number" required value="{$product['stock']}" >
                            <button type="submit">Mettre à jour</button>
                        </form>
                    </div>

            HTML;
        }
        return $domProducts;
    }

}