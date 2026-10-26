<?php

declare(strict_types=1);

namespace Myapp;

final readonly class Greeting
{
    public function __construct(private string $name) {}

    public function message(): string
    {
        return sprintf('Hello, %s!', $this->name);
    }
}
