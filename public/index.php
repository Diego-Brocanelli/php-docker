<!DOCTYPE html>
<html lang="pt-BR">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PHP Docker V3 - Fácil e Rápido</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            /* Light mode colors */
            --bg-primary: #ffffff;
            --bg-secondary: #f9fafb;
            --bg-tertiary: #f8f9fa;
            --bg-card: #ffffff;
            --bg-code: #1f2937;
            --bg-terminal: #111827;
            --bg-terminal-header: #1f2937;
            
            --text-primary: #111827;
            --text-secondary: #374151;
            --text-tertiary: #6b7280;
            --text-muted: #9ca3af;
            
            --border-primary: #e5e7eb;
            --border-secondary: #d1d5db;
            --border-hover: #bdc3c7;
            
            --accent-primary: #27ae60;
            --accent-secondary: #2ecc71;
            --accent-dark: #2c3e50;
            --accent-gray: #34495e;
            --accent-light: #ecf0f1;
            
            --shadow-light: rgba(0, 0, 0, 0.1);
            --shadow-medium: rgba(0, 0, 0, 0.15);
        }

        [data-theme="dark"] {
            /* Dark mode colors */
            --bg-primary: #0f172a;
            --bg-secondary: #1e293b;
            --bg-tertiary: #334155;
            --bg-card: #1e293b;
            --bg-code: #0f172a;
            --bg-terminal: #020617;
            --bg-terminal-header: #0f172a;
            
            --text-primary: #f1f5f9;
            --text-secondary: #e2e8f0;
            --text-tertiary: #cbd5e1;
            --text-muted: #94a3b8;
            
            --border-primary: #334155;
            --border-secondary: #475569;
            --border-hover: #64748b;
            
            --accent-primary: #10b981;
            --accent-secondary: #34d399;
            --accent-dark: #1e40af;
            --accent-gray: #3b82f6;
            --accent-light: #1e293b;
            
            --shadow-light: rgba(0, 0, 0, 0.3);
            --shadow-medium: rgba(0, 0, 0, 0.4);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Nunito', ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif;
            line-height: 1.6;
            overflow-x: hidden;
            background: var(--bg-primary);
            color: var(--text-secondary);
            transition: background-color 0.3s ease, color 0.3s ease;
        }

        /* Dark mode toggle button */
        .theme-toggle {
            position: relative;
            background: var(--accent-light);
            border: 2px solid var(--border-primary);
            border-radius: 50px;
            width: 50px;
            height: 26px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            padding: 2px;
        }

        .theme-toggle:hover {
            border-color: var(--border-hover);
        }

        .theme-toggle-slider {
            position: absolute;
            width: 18px;
            height: 18px;
            background: var(--accent-primary);
            border-radius: 50%;
            transition: transform 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 10px;
        }

        [data-theme="dark"] .theme-toggle-slider {
            transform: translateX(24px);
        }

        /* Laravel-style Header */
        header {
            position: fixed;
            top: 0;
            width: 100%;
            z-index: 1000;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border-primary);
            transition: all 0.3s ease;
        }

        [data-theme="dark"] header {
            background: rgba(15, 23, 42, 0.95);
        }

        nav {
            max-width: 1280px;
            margin: 0 auto;
            padding: 1rem 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-right {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .logo {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--accent-dark);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .logo i {
            font-size: 2rem;
            color: var(--accent-gray);
        }

        .nav-links {
            display: flex;
            list-style: none;
            gap: 2.5rem;
            align-items: center;
        }

        .nav-links a {
            color: var(--text-tertiary);
            text-decoration: none;
            font-weight: 600;
            font-size: 0.95rem;
            transition: color 0.3s ease;
            letter-spacing: 0.025em;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .nav-links a:hover {
            color: var(--accent-dark);
        }

        .nav-cta {
            background: var(--accent-dark);
            color: white;
            padding: 0.625rem 1.25rem;
            border-radius: 0.5rem;
            text-decoration: none;
            font-weight: 600;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }

        .nav-cta:hover {
            background: var(--accent-gray);
            transform: translateY(-1px);
        }

        /* Laravel-style Hero */
        .hero {
            padding: 8rem 2rem 4rem;
            text-align: center;
            background: linear-gradient(135deg, var(--bg-primary) 0%, var(--bg-secondary) 100%);
        }

        .hero-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .hero-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            background: var(--accent-light);
            border: 1px solid var(--border-hover);
            color: var(--accent-dark);
            padding: 0.5rem 1rem;
            border-radius: 50px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 2rem;
        }

        .hero h1 {
            font-size: clamp(3rem, 8vw, 4.5rem);
            font-weight: 800;
            color: var(--text-primary);
            margin-bottom: 1.5rem;
            letter-spacing: -0.025em;
            line-height: 1.1;
        }

        .hero .subtitle {
            font-size: 1.25rem;
            color: var(--text-tertiary);
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
            background: var(--accent-primary);
            color: white;
            border: 2px solid var(--accent-primary);
        }

        .btn-primary:hover {
            background: var(--accent-secondary);
            border-color: var(--accent-secondary);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px rgba(39, 174, 96, 0.4);
        }

        .btn-secondary {
            background: var(--bg-card);
            color: var(--text-secondary);
            border: 2px solid var(--border-secondary);
        }

        .btn-secondary:hover {
            border-color: var(--border-hover);
            transform: translateY(-2px);
            box-shadow: 0 10px 25px -5px var(--shadow-light);
        }

        /* Trusted companies section */
        .trusted-by {
            text-align: center;
            color: var(--text-muted);
            font-size: 0.875rem;
            font-weight: 500;
            margin-bottom: 2rem;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        .companies {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 3rem;
            flex-wrap: wrap;
            opacity: 0.6;
        }

        .company-logo {
            font-size: 1.5rem;
            color: var(--text-muted);
            transition: opacity 0.3s ease;
        }

        .company-logo:hover {
            opacity: 1;
        }

        /* Laravel-style sections */
        .section {
            padding: 6rem 2rem;
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
            color: var(--text-primary);
            margin-bottom: 1rem;
            letter-spacing: -0.025em;
        }

        .section-subtitle {
            font-size: 1.125rem;
            color: var(--text-tertiary);
            max-width: 600px;
            margin: 0 auto;
        }

        /* Feature cards grid */
        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 3rem;
            margin-top: 4rem;
        }

        .feature-card {
            background: var(--bg-card);
            border: 2px solid var(--border-primary);
            border-radius: 1.25rem;
            padding: 2.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            text-align: center;
        }

        .feature-card:hover {
            border-color: var(--border-hover);
            box-shadow: 0 25px 50px -12px var(--shadow-medium);
            transform: translateY(-5px);
        }

        .feature-icon {
            width: 4rem;
            height: 4rem;
            background: var(--accent-light);
            border-radius: 1rem;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 2rem;
            color: var(--accent-dark);
            font-size: 1.5rem;
        }

        .feature-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 1rem;
        }

        .feature-card p {
            color: var(--text-tertiary);
            line-height: 1.7;
            font-size: 1.1rem;
        }

        /* Code section - Laravel style */
        .code-section {
            background: var(--bg-code);
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
            background: var(--bg-terminal);
            border-radius: 0.75rem;
            overflow: hidden;
            max-width: 800px;
            margin: 0 auto;
            text-align: left;
            border: 1px solid var(--border-secondary);
        }

        .terminal-header {
            background: var(--bg-terminal-header);
            padding: 1rem 1.5rem;
            border-bottom: 1px solid var(--border-secondary);
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

        .terminal-dot:nth-child(1) { background: var(--accent-dark); }
        .terminal-dot:nth-child(2) { background: var(--accent-gray); }
        .terminal-dot:nth-child(3) { background: var(--accent-primary); }

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
            background: linear-gradient(135deg, var(--bg-tertiary) 0%, var(--accent-light) 100%);
            padding: 5rem 2rem;
            margin: 2rem 0;
        }

        .stats-container {
            max-width: 70%;
            margin: 0 auto;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 4rem;
            text-align: center;
        }

        .stat-item {
            transition: all 0.3s ease;
        }

        .stat-item:hover {
            transform: translateY(-5px);
        }

        .stat-number {
            font-size: 4rem;
            font-weight: 900;
            color: var(--accent-primary);
            display: block;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(39, 174, 96, 0.1);
        }

        .stat-label {
            color: var(--text-primary);
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            font-size: 1.1rem;
        }

        /* Laravel-style footer */
        footer {
            background: var(--bg-terminal);
            color: var(--text-muted);
            padding: 4rem 2rem 2rem;
        }

        .footer-container {
            max-width: 1280px;
            margin: 0 auto;
        }

        .footer-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
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
            color: var(--text-muted);
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section a:hover {
            color: var(--accent-primary);
        }

        .footer-bottom {
            padding-top: 2rem;
            border-top: 1px solid var(--border-secondary);
            text-align: center;
            font-size: 0.875rem;
        }

        /* Responsive */
        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }
            
            .nav-right {
                gap: 1rem;
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

            .companies {
                gap: 1.5rem;
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
            <a class="logo">
                <i class="fab fa-php"></i>
                PHP Docker
            </a>
            <div class="nav-right">
                <ul class="nav-links">
                    <li>
                        <a href="https://github.com/Diego-Brocanelli/php-docker"><i class="fas fa-book"></i> Documentação</a>
                    </li>
                </ul>

                <button class="theme-toggle" onclick="toggleTheme()" aria-label="Toggle dark mode">
                    <div class="theme-toggle-slider">
                        <i class="fas fa-sun" id="theme-icon"></i>
                    </div>
                </button>
            </div>
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
                <a href="#code-section" class="btn btn-primary">
                    <i class="fas fa-download"></i>
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
                <p>PHP, Nginx, MySQL, Redis e phpMyAdmin configurados e integrados. Tudo que você precisa em um só lugar.</p>
            </div>
        </div>
    </section>

    <!-- Code Section -->
    <section class="code-section" id="code-section">
        <div class="code-container">
            <h2>Simples como deve ser</h2>
            <p class="subtitle">Três comandos e você está pronto para desenvolver</p>
            
            <div class="terminal-window">
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
                        <span class="terminal-command">git clone https://github.com/Diego-Brocanelli/php-docker.git</span>
                    </div>
                    <div class="terminal-line terminal-output">
                        Cloning into 'php-docker-v3'...
                    </div>
                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">cd php-docker-v3</span>
                    </div>
                    <div class="terminal-line">
                        <span class="terminal-prompt">$</span> 
                        <span class="terminal-command">docker-compose up -d</span>
                    </div>
                    <div class="terminal-line terminal-success">✓ Container php-app started</div>
                    <div class="terminal-line terminal-success">✓ Container nginx started</div>
                    <div class="terminal-line terminal-success">✓ Container mysql started</div>
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
                    <span class="stat-label">Setup</span>
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

                        <li><a href="https://diegobrocanelli.com.br/">Blog</a></li>
                    </ul>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2025 PHP Docker V3. Desenvolvido com ❤️ para a comunidade PHP.</p>
            </div>
        </div>
    </footer>

    <script>
        // Theme toggle functionality
        function toggleTheme() {
            const html = document.documentElement;
            const themeIcon = document.getElementById('theme-icon');
            const currentTheme = html.getAttribute('data-theme');
            
            if (currentTheme === 'dark') {
                html.removeAttribute('data-theme');
                themeIcon.className = 'fas fa-sun';
                localStorage.setItem('theme', 'light');
            } else {
                html.setAttribute('data-theme', 'dark');
                themeIcon.className = 'fas fa-moon';
                localStorage.setItem('theme', 'dark');
            }
        }

        // Initialize theme on page load
        function initTheme() {
            const savedTheme = 'dark'; // Default to dark mode
            const themeIcon = document.getElementById('theme-icon');
            
            // Set dark mode as default
            document.documentElement.setAttribute('data-theme', 'dark');
            themeIcon.className = 'fas fa-moon';
        }

        // Initialize theme when DOM is loaded
        document.addEventListener('DOMContentLoaded', initTheme);

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
            const currentTheme = document.documentElement.getAttribute('data-theme');
            
            if (window.scrollY > 50) {
                if (currentTheme === 'dark') {
                    header.style.background = 'rgba(15, 23, 42, 0.98)';
                } else {
                    header.style.background = 'rgba(255, 255, 255, 0.98)';
                }
                header.style.borderColor = 'var(--border-secondary)';
            } else {
                if (currentTheme === 'dark') {
                    header.style.background = 'rgba(15, 23, 42, 0.95)';
                } else {
                    header.style.background = 'rgba(255, 255, 255, 0.95)';
                }
                header.style.borderColor = 'var(--border-primary)';
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
