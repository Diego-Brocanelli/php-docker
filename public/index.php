<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Docker V3 - Fácil e Rápido</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Nunito', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            line-height: 1.6;
            overflow-x: hidden;
            background: #ffffff;
            color: #374151;
        }

        /* Laravel-style Header */
        header {
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid #e5e7eb;
            transition: all 0.3s ease;
        }

        nav {
            max-width: 1280px;
            margin: 0 auto;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: #ef4444;
            text-decoration: none;
        }

        .logo i {
            font-size: 2rem;
            color: #ef4444;
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 2.5rem;
            align-items: center;
        }

        .nav-links a {
            color: #6b7280;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.3s ease;
            letter-spacing: 0.025em;
        }

        .nav-links a:hover {
            color: #ef4444;
        }

        .nav-cta {
            background: #ef4444;
            color: white;
            padding: 0.625rem 1.25rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }

        .nav-cta:hover {
            background: #dc2626;
            transform: translateY(-1px);
        }

        /* Laravel-style Hero */
        .hero {
            padding: 8rem 2rem 2rem;
            text-align: center;
            background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
        }

        .hero-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        .hero h1 {
            font-size: clamp(3rem, 8vw, 4.5rem);
            font-weight: 800;
            color: #111827;
            margin-bottom: 1.5rem;
            letter-spacing: -0.025em;
            line-height: 1.1;
        }

        .hero .subtitle {
            font-size: 1.25rem;
            color: #6b7280;
            margin-bottom: 3rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.6;
        }

        .cta-buttons {
            display: flex;
            gap: 1rem;
            justify-content: center;
            flex-wrap: wrap;
            margin-bottom: 4rem;
        }

        .btn {
            padding: 0.875rem 2rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }

        .btn-primary {
            background: #ef4444;
            color: white;
            border: 2px solid #ef4444;
        }

        .btn-primary:hover {
            background: #dc2626;
            border-color: #dc2626;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(239, 68, 68, 0.4);
        }

        .btn-secondary {
            background: white;
            color: #374151;
            border: 2px solid #d1d5db;
        }

        .btn-secondary:hover {
            border-color: #9ca3af;
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.1);
        }

        /* Laravel-style sections */
        .section {
            padding: 1rem 2rem 2rem;
            max-width: 1280px;
            margin: 0 auto;
        }

        .section-header {
            text-align: center;
            margin-bottom: 4rem;
        }

        .section-title {
            font-size: 2.5rem;
            font-weight: 800;
            color: #111827;
            margin-bottom: 1rem;
            letter-spacing: -0.025em;
        }

        .section-subtitle {
            font-size: 1.125rem;
            color: #6b7280;
            max-width: 600px;
            margin: 0 auto;
        }

        /* Feature cards grid */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 2rem;
            margin-top: 3rem;
        }

        .feature-card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 1rem;
            padding: 2rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .feature-card:hover {
            border-color: #fca5a5;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.08);
            transform: translateY(-2px);
        }

        .feature-icon {
            width: 3rem;
            height: 3rem;
            background: #fef2f2;
            border-radius: 0.75rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 1.5rem;
            color: #ef4444;
            font-size: 1.25rem;
        }

        .feature-card h3 {
            font-size: 1.25rem;
            font-weight: 700;
            color: #111827;
            margin-bottom: 0.75rem;
        }

        .feature-card p {
            color: #6b7280;
            line-height: 1.6;
        }

        /* Code section - Laravel style */
        .code-section {
            background: #1f2937;
            padding: 6rem 2rem;
            margin: 4rem 0;
        }

        .code-container {
            max-width: 1280px;
            margin: 0 auto;
            text-align: center;
        }

        .code-section h2 {
            font-size: 2.5rem;
            font-weight: 800;
            color: #ffffff;
            margin-bottom: 1rem;
        }

        .code-section .subtitle {
            font-size: 1.125rem;
            color: #9ca3af;
            margin-bottom: 3rem;
        }

        .terminal-window {
            background: #111827;
            border-radius: 0.75rem;
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
            text-align: left;
            border: 1px solid #374151;
        }

        .terminal-header {
            background: #1f2937;
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #374151;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .terminal-dots {
            display: flex;
            gap: 0.25rem;
        }

        .terminal-dot {
            width: 0.75rem;
            height: 0.75rem;
            border-radius: 50%;
        }

        .terminal-dot:nth-child(1) { background: #ef4444; }
        .terminal-dot:nth-child(2) { background: #f59e0b; }
        .terminal-dot:nth-child(3) { background: #10b981; }

        .terminal-title {
            margin-left: 1rem;
            color: #d1d5db;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .terminal-content {
            padding: 1.5rem;
            font-family: 'SF Mono', 'Monaco', 'Inconsolata', 'Roboto Mono', 'Source Code Pro', monospace;
            font-size: 0.875rem;
            line-height: 1.6;
        }

        .terminal-line {
            margin-bottom: 0.75rem;
        }

        .terminal-prompt {
            color: #10b981;
        }

        .terminal-command {
            color: #60a5fa;
        }

        .terminal-output {
            color: #9ca3af;
            margin-left: 0;
        }

        .terminal-success {
            color: #10b981;
        }

        /* Stats section */
        .stats-section {
            background: #f9fafb;
            padding: 4rem 2rem;
        }

        .stats-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 2rem;
            text-align: center;
        }

        .stat-item {
            padding: 2rem 1rem;
        }

        .stat-number {
            font-size: 3rem;
            font-weight: 800;
            color: #ef4444;
            display: block;
            margin-bottom: 0.5rem;
        }

        .stat-label {
            color: #6b7280;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-size: 0.875rem;
        }

        /* Laravel-style footer */
        footer {
            background: #111827;
            color: #9ca3af;
            padding: 4rem 2rem 2rem;
        }

        .footer-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 3rem;
            margin-bottom: 3rem;
        }

        .footer-brand h3 {
            color: #ffffff;
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .footer-brand p {
            line-height: 1.6;
            margin-bottom: 1.5rem;
        }

        .footer-section h4 {
            color: #ffffff;
            font-weight: 600;
            margin-bottom: 1rem;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section li {
            margin-bottom: 0.5rem;
        }

        .footer-section a {
            color: #9ca3af;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: #ef4444;
        }

        .footer-bottom {
            padding-top: 2rem;
            border-top: 1px solid #374151;
            text-align: center;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            
            .cta-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 280px;
                justify-content: center;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .footer-content {
                grid-template-columns: 1fr;
                text-align: center;
            }
        }

        /* Animations */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.8s ease forwards;
        }

        .delay-1 { animation-delay: 0.2s; opacity: 0; }
        .delay-2 { animation-delay: 0.4s; opacity: 0; }
        .delay-3 { animation-delay: 0.6s; opacity: 0; }
    </style>
</head>
<body>
    <!-- Header -->
    <header>
        <nav>
            <a href="https://github.com/Diego-Brocanelli/php-docker" class="logo">
                <i class="fab fa-php"></i>
                PHP Docker
            </a>
            <ul class="nav-links">
                <li><a href="#features">Features</a></li>
                <li><a href="https://github.com/Diego-Brocanelli/php-docker">Documentação</a></li>
            </ul>
        </nav>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-container">
            <div class="hero-badge fade-in-up">
                <i class="fas fa-rocket"></i>
                Versão 3.0 Disponível
            </div>
            <h1 class="fade-in-up delay-1">PHP Docker</h1>
            <p class="subtitle fade-in-up delay-2">
                Desenvolvimento PHP com Docker de forma <strong>fácil e rápida</strong>. 
                Configure seu ambiente completo em segundos e foque no que realmente importa: seu código.
            </p>
            <div class="cta-buttons fade-in-up delay-3">
                <a href="#features" class="btn btn-primary">
                    <i class="fa-solid fa-code"></i>
                    Começar Agora
                </a>
                <a href="https://github.com/Diego-Brocanelli/php-docker" class="btn btn-secondary">
                    <i class="fab fa-github"></i>
                    Ver no GitHub
                </a>
            </div>
        </div>
    </section>

    <!-- Features Section -->
    <section class="section" id="features">
        <div class="section-header">
            <h2 class="section-title">Desenvolvimento sem complicações</h2>
            <p class="section-subtitle">
                Oferecemos soluções elegantes para as funcionalidades comuns necessárias em todos os projetos PHP modernos.
            </p>
        </div>
        
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-rocket"></i>
                </div>
                <h3>Configuração Instantânea</h3>
                <p>Configure seu ambiente PHP completo em segundos. Sem complicações, sem dependências conflitantes. Simplesmente funciona.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fab fa-docker"></i>
                </div>
                <h3>Docker Otimizado</h3>
                
                <p>Containers Docker otimizados para PHP, com todas as extensões necessárias pré-configuradas e prontas para produção.</p>
            </div>
            
            <div class="feature-card">
                <div class="feature-icon">
                    <i class="fas fa-layer-group"></i>
                </div>
                
                <h3>Stack Completa</h3>
                
                <p>PHP, Nginx, MySQL, PostgreSql, MongoDB, RabbitMQ, Redis e MailHog configurados e integrados. Tudo que você precisa em um só lugar.</p>
            </div>
        </div>
    </section>

    <!-- Code Section -->
    <section class="code-section">
        <div class="code-container">
            <h2>Simples como deve ser</h2>
            <p class="subtitle">Em poucos comandos e você está pronto para desenvolver</p>
            
            <div class="terminal-window" id="terminal-window">
                <div class="terminal-header">
                    <div class="terminal-dots">
                        <div class="terminal-dot"></div>
                        <div class="terminal-dot"></div>
                        <div class="terminal-dot"></div>
                    </div>
                    <div class="terminal-title">Terminal</div>
                </div>
                <div class="terminal-content">
                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">git clone https://github.com/Diego-Brocanelli/php-docker</span>
                    </div>

                    <div class="terminal-line terminal-output">
                        Cloning into 'php-docker'...
                    </div>

                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">cd php-docker</span>
                    </div>

                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">make setup</span>
                    </div>

                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">Digite o nome do projeto: MyProject </span>
                    </div>
                    
                    <div class="terminal-line terminal-success">✓ Container app-php started</div>

                    <div class="terminal-line terminal-success">✓ Container app-nginx started</div>

                    <div class="terminal-line terminal-success">✓ Container app-postgresql started</div>

                    <div class="terminal-line terminal-success">✓ Your application is ready at http://localhost:8888</div>
                </div>
            </div>
        </div>
    </section>

    <!-- Stats Section -->
    <section class="stats-section">
        <div class="stats-container">
            <div class="stats-grid">
                <div class="stat-item">
                    <span class="stat-number">< 30s</span>

                    <span class="stat-label">Tempo de Setup</span>
                </div>
                <div class="stat-item">
                    <span class="stat-number">100%</span>

                    <span class="stat-label">Compatível</span>
                </div>

                <div class="stat-item">
                    <span class="stat-number">0</span>

                    <span class="stat-label">Configuração</span>
                </div>

                <div class="stat-item">
                    <span class="stat-number">∞</span>

                    <span class="stat-label">Possibilidades</span>
                </div>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer>
        <div class="footer-container">
            <div class="footer-content">
                <div class="footer-brand">
                    <h3><i class="fab fa-php"></i> PHP Docker</h3>
                    <p>Desenvolvimento PHP com Docker de forma fácil e rápida. Oferecemos um ecossistema completo para desenvolvedores PHP que querem focar no que realmente importa.</p>
                </div>
                
                <div class="footer-section">
                    <h4>Comunidade</h4>

                    <ul>
                        <li><a href="https://github.com/Diego-Brocanelli/php-docker">GitHub</a></li>
                        
                        <li><a href="https://x.com/diego_b2">X</a></li>
                        
                        <li><a href="https://diegobrocanelli.com.br/about/">Autor</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; <?= date('Y') ?> PHP Docker Desenvolvido com ❤️ para a comunidade PHP.</p>
            </div>
        </div>
    </footer>

    <script>
        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Header scroll effect
        window.addEventListener('scroll', () => {
            const header = document.querySelector('header');
            if (window.scrollY > 50) {
                header.style.background = 'rgba(255, 255, 255, 0.98)';
                header.style.borderColor = '#d1d5db';
            } else {
                header.style.background = 'rgba(255, 255, 255, 0.95)';
                header.style.borderColor = '#e5e7eb';
            }
        });

        // Intersection Observer for animations
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.style.opacity = '1';
                    entry.target.style.transform = 'translateY(0)';
                }
            });
        }, observerOptions);

        // Observe feature cards
        document.querySelectorAll('.feature-card').forEach((card, index) => {
            card.style.opacity = '0';
            card.style.transform = 'translateY(30px)';
            card.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
            observer.observe(card);
        });

        // Observe stats
        document.querySelectorAll('.stat-item').forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateY(30px)';
            item.style.transition = `opacity 0.6s ease ${index * 0.1}s, transform 0.6s ease ${index * 0.1}s`;
            observer.observe(item);
        });
    </script>
</body>
</html>
