// Smooth scroll for nav links
document.querySelectorAll('nav a').forEach(link => {
    link.addEventListener('click', function(e) {
        const href = this.getAttribute('href');
        if (href.startsWith('#')) {
            e.preventDefault();
            document.querySelector(href).scrollIntoView({
                behavior: 'smooth'
            });
        }
    });
});

// Highlight nav item on scroll
const sections = Array.from(document.querySelectorAll('main section'));
const navLinks = Array.from(document.querySelectorAll('nav a'));

function highlightNav() {
    let scrollPos = window.scrollY + 80;
    let current = sections[0].id;
    for (let section of sections) {
        if (section.offsetTop <= scrollPos) {
            current = section.id;
        }
    }
    navLinks.forEach(link => {
        link.classList.toggle('active', link.getAttribute('href') === '#' + current);
    });
}
window.addEventListener('scroll', highlightNav);

// Add simple hover effect to feature sections
document.querySelectorAll('.feature').forEach(feature => {
    feature.addEventListener('mouseenter', () => {
        feature.style.boxShadow = '0 4px 24px #2223';
    });
    feature.addEventListener('mouseleave', () => {
        feature.style.boxShadow = '0 2px 16px #0001';
    });
});

// Optional: Animate hero text on load
window.addEventListener('DOMContentLoaded', () => {
    const heroText = document.querySelector('.hero-content h2');
    if (heroText) {
        heroText.style.opacity = 0;
        heroText.style.transform = 'translateY(30px)';
        setTimeout(() => {
            heroText.style.transition = 'opacity 0.8s, transform 0.8s';
            heroText.style.opacity = 1;
            heroText.style.transform = 'translateY(0)';
        }, 300);
    }
});