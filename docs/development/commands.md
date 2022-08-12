# Comandos disponíveis

Abaixo temos listados os exemplos dos comandos para utilizar todos os recursos que o container disponibiliza

## PHP

```bash
docker exec -i app php --version
```

## PHPStan

```bash
docker exec -i app phpstan --version 
```

Annálise de código.

```bash
docker exec -i app phpstan analyse src tests --level=9
```

## PHPCs

```bash
docker exec -i app phpcs --version
```

## PHPUnit

```bash
docker exec -i app phpunit --version
```

Executando a switch de testes

```bash
docker exec -i app phpunit tests
```

## Psalm

```bash
docker exec -i app psalm --version
```

## PHPLoc

```bash
docker exec -i app phploc --version
```

Executando análise

```bash
docker exec -i app phploc src/
```

## Composer

```bash
docker exec -i app composer --version 
```

## Composer-unused

```bash
docker exec -i app composer-unused --version 
```

## NodeJs

```bash
docker exec -i app node --version
```

## NPM

```bash
docker exec -i app npm --version
```
