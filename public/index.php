<?php declare(strict_types=1); ?>
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>PHP 8.4 Docker Environment</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        body {
            background: #f7f7f7;
            font-family: 'Segoe UI', Arial, sans-serif;
            margin: 0;
            padding: 0;
        }
        .container {
            max-width: 540px;
            margin: 60px auto;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.08);
            padding: 32px 28px;
            text-align: center;
        }
        h1, h2 {
            color: #0070f3;
            margin-bottom: 12px;
        }
        .tech-list {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 16px;
            margin: 32px 0 24px 0;
            padding: 0;
            list-style: none;
        }
        .tech-list li {
            background: #f0f4fa;
            border-radius: 6px;
            padding: 12px 20px;
            font-weight: 500;
            color: #222;
            box-shadow: 0 1px 4px rgba(0,0,0,0.03);
            font-size: 1.05em;
        }
        .desc {
            color: #444;
            font-size: 1.08em;
            margin-bottom: 24px;
        }
        .section-title {
            font-size: 1.15em;
            color: #0070f3;
            margin: 36px 0 12px 0;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .commands {
            background: #f0f4fa;
            border-radius: 8px;
            text-align: left;
            padding: 18px 18px 12px 18px;
            margin: 0 auto 18px auto;
            font-size: 1em;
            max-width: 420px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.03);
        }
        .commands code {
            background: #eaeaea;
            border-radius: 4px;
            padding: 2px 6px;
            font-size: 0.98em;
        }
        .repo-link, .readme-link {
            display: inline-block;
            margin-top: 18px;
            padding: 10px 22px 10px 18px;
            background: #0070f3;
            color: #fff;
            border-radius: 5px;
            text-decoration: none;
            font-weight: 600;
            transition: background 0.2s;
            position: relative;
            font-size: 1em;
        }
        .repo-link:hover, .readme-link:hover {
            background: #005bb5;
        }
        .readme-link {
            background: #222;
            margin-left: 10px;
        }
        .repo-link svg, .readme-link svg {
            vertical-align: middle;
            margin-right: 8px;
            margin-bottom: 2px;
            width: 20px;
            height: 20px;
            fill: currentColor;
        }
        .tree-struct {
            background: #f8fafc;
            border-radius: 8px;
            text-align: left;
            padding: 18px 18px 12px 18px;
            margin: 32px auto 18px auto;
            font-size: 0.98em;
            max-width: 540px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.03);
            font-family: "Fira Mono", "Consolas", "Menlo", monospace;
        }
        .tree-struct .comment {
            color: #888;
            font-style: italic;
            margin-left: 8px;
        }
        @media (max-width: 600px) {
            .container { padding: 18px 6px; }
            .tech-list li { padding: 10px 12px; font-size: 0.98em; }
            .commands { padding: 12px 4px 8px 8px; }
            .repo-link, .readme-link { font-size: 0.98em; padding: 10px 10px 10px 10px; }
            .tree-struct { padding: 12px 4px 8px 8px; }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Seja bem-vindo!</h1>
        <h2>PHP 8.4 Docker Environment</h2>
        <p class="desc">
            Um ambiente moderno e pronto para desenvolvimento PHP, com tudo que você precisa para criar aplicações robustas e escaláveis.<br>
            <strong>Ideal para equipes e projetos individuais!</strong>
        </p>
        <ul class="tech-list">
            <li>PHP 8.4 (FPM)</li>
            <li>Nginx</li>
            <li>MySQL 8.0</li>
            <li>Redis 7.0</li>
            <li>Docker &amp; Docker Compose</li>
            <li>Configuração via .env</li>
            <li>Scripts de inicialização</li>
            <li>Testes automatizados</li>
        </ul>
        <div class="section-title">Estrutura do Projeto</div>
        <pre class="tree-struct">
.
├── docker/       <span class="comment"># Arquivos Docker</span>
├── docs/         <span class="comment"># Documentação do projeto</span>
├── public/       <span class="comment"># Raiz pública da aplicação</span>
│   └── index.php <span class="comment"># Arquivo inicial da aplicação</span>
├── src/          <span class="comment"># Código-fonte do projeto</span>
├── tests/        <span class="comment"># Testes automatizados</span>
├── .env          <span class="comment"># Arquivo de variáveis de ambiente</span>
├── Makefile      <span class="comment"># Ferramenta auxiliar</span>
├── setup.sh      <span class="comment"># Script de configuração inicial</span>
        </pre>
        <div class="section-title">Comandos úteis</div>
        <div class="commands">
            <strong>Clonar e iniciar:</strong><br>
            <code>git clone https://github.com/Diego-Brocanelli/php-docker.git [nome_projeto]</code><br>
            <code>cd [nome_projeto]</code><br>
            <code>chmod +x setup.sh</code><br>
            <code>./setup.sh</code>
            <br><br>
            <strong>Ambiente web completo:</strong><br>
            <code>./setup.sh --web</code>
            <br><br>
            <strong>Apenas ambiente CLI (PHP + MySQL):</strong><br>
            <code>./setup.sh --cli</code>
            <br><br>
            <strong>Adicionar Redis ao ambiente:</strong><br>
            <code>./setup.sh --web --with-redis</code>
            <br><br>
            <strong>Usar um arquivo .env específico:</strong><br>
            <code>./setup.sh --env meu-ambiente.env</code>
            <br><br>
            <strong>Ver todas as opções:</strong><br>
            <code>./setup.sh --help</code>
            <br><br>
            <strong>Comandos Makefile:</strong><br>
            <code>make up</code> — Sobe todos os containers<br>
            <code>make down</code> — Para e remove todos os containers<br>
            <code>make sh</code> — Sobe e acessa o bash do container PHP<br>
        </div>
        <a class="repo-link" href="https://github.com/Diego-Brocanelli/php-docker" target="_blank">
            <!-- GitHub SVG -->
            <svg viewBox="0 0 16 16" aria-hidden="true">
                <path d="M8 0C3.58 0 0 3.58 0 8c0 3.54 2.29 6.53 5.47 7.59.4.07.55-.17.55-.38
                0-.19-.01-.82-.01-1.49-2.01.37-2.53-.49-2.69-.94-.09-.23-.48-.94-.82-1.13-.28-.15-.68-.52
                -.01-.53.63-.01 1.08.58 1.23.82.72 1.21 1.87.87 2.33.66.07-.52.28-.87.51-1.07-1.78-.2
                -3.64-.89-3.64-3.95 0-.87.31-1.59.82-2.15-.08-.2-.36-1.02.08-2.12 0 0 .67-.21 2.2.82.64
                -.18 1.32-.27 2-.27.68 0 1.36.09 2 .27 1.53-1.04 2.2-.82 2.2-.82.44 1.1.16 1.92.08
                2.12.51.56.82 1.27.82 2.15 0 3.07-1.87 3.75-3.65 3.95.29.25.54.73.54 1.48 0 1.07-.01
                1.93-.01 2.19 0 .21.15.46.55.38A8.013 8.013 0 0 0 16 8c0-4.42-3.58-8-8-8z"></path>
            </svg>
            GitHub
        </a>
        <a class="readme-link" href="https://github.com/Diego-Brocanelli/php-docker/blob/main/README.md" target="_blank">
            <!-- Book SVG -->
            <svg viewBox="0 0 24 24" aria-hidden="true">
                <path d="M19 2H8a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h11a1 1 0 0 0 1-1V3a1 1 0 0 0-1-1zm-1 16H9V4h9zm-9 2V4a1 1 0 0 1 1-1h1v16H9a1 1 0 0 1-1-1z"/>
            </svg>
            Documentação
        </a>
    </div>
</body>
</html>
