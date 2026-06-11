const navToggle = document.querySelector('.nav-toggle');
const navLinks = document.querySelector('#mobileNav');

if (navToggle && navLinks) {
  navToggle.addEventListener('click', () => {
    const open = navLinks.classList.toggle('open');
    navToggle.setAttribute('aria-expanded', String(open));
  });
}

function activateById(buttons, panels, idPrefix, key) {
  buttons.forEach((button) => {
    const active = button.dataset[idPrefix] === key;
    button.classList.toggle('active', active);
    button.setAttribute('aria-selected', String(active));
  });
  panels.forEach((panel) => panel.classList.toggle('active', panel.id === `${idPrefix}-${key}`));
}

const shotTabs = document.querySelectorAll('.shot-tab');
const shotPanels = document.querySelectorAll('.shot-panel');
shotTabs.forEach((button) => {
  button.addEventListener('click', () => activateById(shotTabs, shotPanels, 'shot', button.dataset.shot));
});

const filters = document.querySelectorAll('.filter');
const issues = document.querySelectorAll('.issue');
filters.forEach((button) => {
  button.addEventListener('click', () => {
    const filter = button.dataset.filter;
    filters.forEach((item) => item.classList.toggle('active', item === button));
    issues.forEach((issue) => {
      const tags = issue.dataset.tags || '';
      issue.classList.toggle('is-hidden', filter !== 'all' && !tags.includes(filter));
    });
  });
});

const checklist = document.querySelector('#seoChecklist');
const progressText = document.querySelector('#progressText');
const progressBar = document.querySelector('#progressBar');

function updateProgress() {
  const checks = [...checklist.querySelectorAll('input[type="checkbox"]')];
  const done = checks.filter((item) => item.checked).length;
  const percent = Math.round((done / checks.length) * 100);
  progressText.textContent = `${percent}%`;
  progressBar.style.width = `${percent}%`;
}

if (checklist) {
  checklist.addEventListener('change', updateProgress);
  updateProgress();
}
