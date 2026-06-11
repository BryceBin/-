const navToggle = document.querySelector('.nav-toggle');
const navLinks = document.querySelector('#navLinks');

if (navToggle && navLinks) {
  navToggle.addEventListener('click', () => {
    const isOpen = navLinks.classList.toggle('open');
    navToggle.setAttribute('aria-expanded', String(isOpen));
  });
}

document.querySelectorAll('.tab').forEach((tab) => {
  tab.addEventListener('click', () => {
    const target = tab.dataset.tab;

    document.querySelectorAll('.tab').forEach((item) => {
      item.classList.toggle('active', item === tab);
      item.setAttribute('aria-selected', String(item === tab));
    });

    document.querySelectorAll('.tab-panel').forEach((panel) => {
      panel.classList.toggle('active', panel.id === `tab-${target}`);
    });
  });
});

const checklist = document.querySelector('#seoChecklist');
const progressRing = document.querySelector('#progressRing');
const progressText = document.querySelector('#progressText');
const progressHint = document.querySelector('#progressHint');

function updateProgress() {
  const checks = Array.from(checklist.querySelectorAll('input[type="checkbox"]'));
  const completed = checks.filter((item) => item.checked).length;
  const percent = Math.round((completed / checks.length) * 100);

  progressRing.style.setProperty('--score', percent);
  progressText.textContent = `${percent}%`;

  if (percent === 0) {
    progressHint.textContent = '先从占位文案、首页标题和产品描述开始。';
  } else if (percent < 40) {
    progressHint.textContent = '已经开始变好，继续处理首页和产品页这些高优先级任务。';
  } else if (percent < 80) {
    progressHint.textContent = '核心基础已完成，下一步重点做集合页、博客和内链。';
  } else {
    progressHint.textContent = '非常好！可以开始关注 Search Console 数据、结构化数据和内容增长。';
  }
}

if (checklist) {
  checklist.addEventListener('change', updateProgress);
  updateProgress();
}
