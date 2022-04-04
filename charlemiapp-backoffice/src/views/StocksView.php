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
                <a href="{$this->container['router']->pathFor('users')}">
                    <button class="stocks">Gestion des utilisateurs</button>
                </a>
            </div>
            <script src="/assets/js/draganddrop.js"></script>
            <script src="/assets/js/xhr-open.js"></script>
        </body>
        </html>
        HTML;
        return genererHeader("Gestion des stocks - CharleMi'App", ["home.css", "stocks.css"]) . $html;
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
                            <input id="datastock" name="stock" class="stockinput" type="number" required value="{$product['stock']}" >
                            <button type="submit">Mettre à jour</button>
                        </form>
                        <a href="{$this->container['router']->pathFor('editProduct', ['id' => $product['id']])}" class="stocks">Modifier</a>
                        <a href="{$this->container['router']->pathFor('deleteProduct', ['id' => $product['id']])}" class="openclose close">Supprimer</a>
                    </div>

            HTML;
        }
        return $domProducts;
    }

    public function renderAddProduct(array $categories): string
    {
        $domCategories = $this->buildDomCategories($categories);
        $html = <<<HTML
            <div class="form">
                <form action="{$this->container['router']->pathFor('addProduct')}" method="POST">
                    <div class="form-element">
                        <label for="name">Nom du produit :</label>
                        <input id="name" name="name" type="text" required>
                    </div>
                    <div class="form-element">
                        <label for="category">Catégorie :</label>
                        <select name="category" id="category">
                            $domCategories
                        </select>
                        <input id="category-new" name="category-new" type="text" hidden>
                    </div>
                    <div class="form-element">
                        <label for="price">Prix</label>
                        <input id="price" name="price" type="number" step="0.01" required>
                    </div>
                    <button type="submit" class="openclose open">Ajouter</button>
                </form>
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <form action="{$this->container['router']->pathFor('openSet')}" method="POST">
                </form>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
                </a>
                <a href="{$this->container['router']->pathFor('home')}">
                    <button class="stocks">Gestion des commandes</button>
                </a>
            </div>
            <script src="/assets/js/category.js"></script>
        </body>
        </html>
        HTML;
        return genererHeader("Ajout produit - CharleMi'App", ["home.css", "stocks.css"]) . $html;
    }

    private function buildDomCategories(array $categories, string $selected = ''): string
    {
        $domCategories = '';
        foreach ($categories as $category) {
            $domCategories .= $selected == $category ?
            <<<HTML
                <option selected value="$category">$category</option>
            HTML
            : <<<HTML
                <option value="$category">$category</option>
            HTML;
        }
        $domCategories .= <<<HTML
            <option value="other">Nouvelle catégorie</option>
        HTML;
        return $domCategories;
    }

    public function renderEditProduct(array $product, array $categories): string
    {
        $domCategories = $this->buildDomCategories($categories, $product['category']);
        $html = <<<HTML
            <div class="form">
                <form action="#" method="POST">
                    <input name="id" value="{$product['id']}" type="hidden" required>
                    <div class="form-element">
                        <label for="name">Nom du produit :</label>
                        <input id="name" name="name" value="{$product['name']}" type="text" required>
                    </div>
                    <div class="form-element">
                        <label for="category">Catégorie :</label>
                        <select name="category" id="category">
                            $domCategories
                        </select>
                    </div>
                    <div class="form-element">
                        <label for="price">Prix</label>
                        <input id="price" name="price" type="number" value="{$product['price']}" step="0.01" required>
                    </div>
                    <button type="submit" class="openclose open">Modifier</button>
                </form>
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <form action="{$this->container['router']->pathFor('openSet')}" method="POST">
                </form>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
                </a>
                <a href="{$this->container['router']->pathFor('home')}">
                    <button class="stocks">Gestion des commandes</button>
                </a>
            </div>
        </body>
        </html>
        HTML;
        return genererHeader("Modification produit - CharleMi'App", ["home.css", "stocks.css"]) . $html;
    }

}