<?php

namespace charlemiapp\exceptions;

use Exception;

class ForbiddenException extends Exception
{

    private static string $title;

    public function __construct(string $title = "Forbidden", string $message = "Forbidden")
    {
        self::$title = $title;
        parent::__construct($message);
    }

    public function getTitle(): string
    {
        return self::$title;
    }
}