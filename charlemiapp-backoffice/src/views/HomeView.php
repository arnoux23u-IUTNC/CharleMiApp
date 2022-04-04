<?php /** @noinspection JSDeprecatedSymbols */

namespace charlemiapp\views;

use JetBrains\PhpStorm\Pure;
use Slim\Container;

class HomeView
{

    private Container $container;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    #[Pure] public function render(array $globalOrders, bool $open): string
    {
        $btn = $open ? "<button id='chg-btn' name='open' value='close' class=\"openclose close\">Close</button>" : "<button id='chg-btn' name='open' value='open' class=\"openclose open\">Open</button>";
        $columnPending = $columnWaiting = $columnDone = $columnDelivered = $columnCanceled = "";
        foreach ($globalOrders as $status => $orders) {
            foreach ($orders as $id => $order) {
                switch ($status) {
                    case "PENDING":
                        $columnPending .= $this->renderColumn($order, $id);
                        break;
                    case "WAITING":
                        $columnWaiting .= $this->renderColumn($order, $id);
                        break;
                    case "DONE":
                        $columnDone .= $this->renderColumn($order, $id);
                        break;
                    case "DELIVERED":
                        $columnDelivered .= $this->renderColumn($order, $id);
                        break;
                    case "CANCELED":
                        $columnCanceled .= $this->renderColumn($order, $id);
                        break;
                }
            }
        }
        $html = <<<HTML
            <div class="refresh">
                <img alt="refresh" id="refresh-img" src="/assets/img/cropped-refresh.png">
            </div>
            <main class="board">
                <div class="column column-pending" data-col-id="pending">
                    <h2>À valider</h2>
                    $columnPending
                </div>
                <div class="column column-waiting" data-col-id="waiting">
                    <h2>En attente</h2>
                    $columnWaiting
                </div>
                <div class="column column-done" data-col-id="done">
                    <h2>Prêtes</h2>
                    $columnDone
                </div>
                <div class="column column-delivered" data-col-id="delivered">
                    <h2>Retirées</h2>
                    $columnDelivered
                </div>
                <div class="column column-canceled" data-col-id="canceled">
                    <h2>Annulées</h2>
                    $columnCanceled
                </div>
            </main>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <form action="{$this->container['router']->pathFor('openSet')}" method="POST">
                    $btn
                </form>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
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
        return genererHeader("Home - CharleMi'App", ["home.css", "draganddrop.css"]) . $html;
    }

    #[Pure] public function noOrders(bool $open): string
    {
        $btn = $open ? "<button id='chg-btn' name='open' value='close' class=\"openclose close\">Close</button>" : "<button id='chg-btn' name='open' value='open' class=\"openclose open\">Open</button>";
        $html = <<<HTML
            <div class="refresh">
                <img alt="refresh" id="refresh-img" src="/assets/img/cropped-refresh.png">
            </div>
            <div class="buttons">
                <a href="{$this->container['router']->pathFor('logout')}">
                    <button class="logout">Logout</button>
                </a>
                <form action="{$this->container['router']->pathFor('openSet')}" method="POST">
                    $btn
                </form>
                <a href="{$this->container['router']->pathFor('stocks')}">
                    <button class="stocks">Gestion des stocks</button>
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
        return genererHeader("Home - CharleMi'App", ["home.css"]) . $html;
    }

    private function renderColumn(array $order, string $id): string
    {
        $date = date_format(date_create($order['timestamp'] ?? ""), 'H:i');
        $dateRetrait = date_format(date_create($order['instructions']['withdrawal'] ?? ""), 'H:i');
        $items = "";
        foreach ($order['items'] as $item) {
            $items .= <<<HTML
                <li>
                    <span class="item-quantity">{$item['qte']}</span>
                    x
                    <span class="item-name">{$item['name']}</span>
                </li>
            HTML;
        }
        return <<<HTML
        <article class="card trigger_popup_fricc" draggable="true" data-id="$id">
                        <h3>Commande {$order['unique_id']}</h3>
                        <h3>Retrait : $dateRetrait</h3>
                        <ul>
        $items
                        </ul>
                        </ul>
                        <h4>$date</h4>
                    </article>
        HTML;
    }
}