const header = document.querySelector('.site-header');
const menuButton = document.querySelector('.nav-toggle');
const navigation = document.querySelector('.site-nav');
const navigationLinks = document.querySelectorAll('.site-nav a');

function closeMenu() {
    menuButton.setAttribute('aria-expanded', 'false');
    menuButton.setAttribute('aria-label', 'Open navigation');
    navigation.classList.remove('open');
    document.body.classList.remove('menu-open');
}

menuButton.addEventListener('click', () => {
    const isOpen = menuButton.getAttribute('aria-expanded') === 'true';
    menuButton.setAttribute('aria-expanded', String(!isOpen));
    menuButton.setAttribute('aria-label', isOpen ? 'Open navigation' : 'Close navigation');
    navigation.classList.toggle('open', !isOpen);
    document.body.classList.toggle('menu-open', !isOpen);
});

navigationLinks.forEach((link) => link.addEventListener('click', closeMenu));

window.addEventListener('scroll', () => {
    header.classList.toggle('scrolled', window.scrollY > 12);
}, { passive: true });

const revealObserver = new IntersectionObserver((entries, observer) => {
    entries.forEach((entry) => {
        if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            observer.unobserve(entry.target);
        }
    });
}, { threshold: 0.12 });

document.querySelectorAll('.reveal').forEach((element) => revealObserver.observe(element));
document.querySelector('#year').textContent = new Date().getFullYear();
