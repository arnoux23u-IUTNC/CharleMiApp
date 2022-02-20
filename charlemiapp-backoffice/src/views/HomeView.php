<?php

namespace charlemiapp\views;

use JetBrains\PhpStorm\Pure;
use Slim\Container;

class HomeView
{

    private Container $container;
    private static int $NB_ORDERS = 0;

    public function __construct(Container $container)
    {
        $this->container = $container;
    }

    #[Pure] public function render(array $globalOrders): string
    {
        $columnPending = $columnWaiting = $columnDone = $columnDelivered = $columnCanceled = "";
        foreach ($globalOrders as $status => $orders) {
            foreach ($orders as $order) {
                switch ($status) {
                    case "PENDING":
                        $columnPending .= $this->renderColumn($order);
                        break;
                    case "WAITING":
                        $columnWaiting .= $this->renderColumn($order);
                        break;
                    case "DONE":
                        $columnDone .= $this->renderColumn($order);
                        break;
                    case "DELIVERED":
                        $columnDelivered .= $this->renderColumn($order);
                        break;
                    case "CANCELED":
                        $columnCanceled .= $this->renderColumn($order);
                        break;
                }
            }
        }

        $html = <<<HTML
            <main class="board">
                <div class="column column-pending" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h2>À valider</h2>
                    $columnPending
                </div>
                <div class="column column-waiting" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h2>En attente</h2>
                    $columnWaiting
                </div>
                <div class="column column-done" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h2>Prêtes</h2>
                    $columnDone
                </div>
                <div class="column column-delivered" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h2>Retirées</h2>
                    $columnDelivered
                </div>
                <div class="column column-canceled" ondrop="drop(event)" ondragover="allowDrop(event)">
                    <h2>Annulées</h2>
                    $columnCanceled
                </div>
            </main>
            <script src="/assets/js/draganddrop.js"></script>
            <a href="{$this->container['router']->pathFor('logout')}">Logout</a>
        </body>
        </html>
        HTML;
        return genererHeader("Home - CharleMi'App", ["draganddrop.css"]) . $html;


        //return  $html;
    }

    #[Pure] public function noOrders(): string
    {
        return genererHeader("Home - CharleMi'App") . <<<HTML
            No ORDERS
        </body>
        </html>
        HTML;
    }

    private function renderColumn(array $order): string
    {
        $this::$NB_ORDERS += 1;
        $date = date_format(date_create($order['timestamp'] ?? ""), 'H:i:s');
        return <<<HTML
        <article class="card" draggable="true" ondragstart="drag(event)" data-id="1">
                        <h3>Commande {$this::$NB_ORDERS}</h3>
                        <h3>$date</h3>
                    </article>
        HTML;
    }

}