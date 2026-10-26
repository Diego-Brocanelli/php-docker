<?php

declare(strict_types=1);

/*
 * Long-running worker executed by the "worker" service (WORKER_COMMAND in .env).
 * Replace the loop body with your queue consumer (Redis, RabbitMQ, Kafka...).
 * After changing this file run: make worker-restart
 */

$running = true;

if (function_exists('pcntl_async_signals')) {
    pcntl_async_signals(true);
    $stop = static function () use (&$running): void {
        $running = false;
    };
    pcntl_signal(SIGTERM, $stop);
    pcntl_signal(SIGINT, $stop);
}

fwrite(STDOUT, sprintf('[%s] Worker started (PID %d)%s', date('c'), getmypid(), PHP_EOL));

while ($running) {
    // TODO: consume a job here.
    fwrite(STDOUT, sprintf('[%s] Worker heartbeat%s', date('c'), PHP_EOL));
    sleep(10);
}

fwrite(STDOUT, sprintf('[%s] Worker stopped gracefully%s', date('c'), PHP_EOL));
