<?php

declare(strict_types=1);

namespace Myapp\Tests;

use Myapp\Greeting;
use PHPUnit\Framework\TestCase;

final class GreetingTest extends TestCase
{
    public function testMessageContainsTheName(): void
    {
        self::assertSame('Hello, World!', (new Greeting('World'))->message());
    }
}
