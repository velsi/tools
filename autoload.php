<?php

spl_autoload_register(function ($class_name) {
    $file = $_SERVER['DOCUMENT_ROOT'] . '/local/lib/' . str_replace('\\', '/', $class_name) . '.php';
    if (is_file($file)) include $file;
});
