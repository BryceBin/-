# Keepstore SEO Interactive Guide

这是一个面向 SEO 零基础用户的静态互动网站，用分步骤讲解、图表、流程图、页面线框图和可勾选清单，介绍 Keepstore.com 的 SEO 现状、优点、缺点和具体优化路径。

## 在线部署到 GitHub Pages

本仓库已经包含 GitHub Pages 自动部署配置：

- 工作流文件：`.github/workflows/github-pages.yml`
- 静态站入口：`index.html`
- 禁用 Jekyll 处理：`.nojekyll`

部署方式：

1. 把本分支合并或推送到 GitHub 仓库的 `main`、`master` 或 `work` 分支。
2. 打开 GitHub 仓库页面，进入 **Settings → Pages**。
3. 在 **Build and deployment** 中把 **Source** 设置为 **GitHub Actions**。
4. 打开 **Actions**，等待 `Deploy static site to GitHub Pages` 工作流完成。
5. 部署成功后，页面地址通常是：

```text
https://<你的 GitHub 用户名或组织名>.github.io/<仓库名>/
```

如果仓库名是 `<你的 GitHub 用户名>.github.io`，地址通常是：

```text
https://<你的 GitHub 用户名>.github.io/
```

## 本地打开方式

如果需要在本地预览，在仓库根目录运行：

```bash
python3 -m http.server 4173
```

然后访问：

```text
http://127.0.0.1:4173/
```

## 页面内容

- `index.html`：网站主体内容，包含 SEO 学习地图、Keepstore 现状诊断、页面优化标签页、网站结构图、90 天路线图和互动清单。
- `styles.css`：视觉样式、响应式布局、图表、卡片、时间线和架构图样式。
- `script.js`：移动端菜单、页面标签页切换和互动清单进度计算。
- `.github/workflows/github-pages.yml`：GitHub Pages 自动部署工作流。

## 适合谁看

- 完全不懂 SEO 的运营、老板、市场同学。
- 不懂代码但需要推动 Shopify 独立站优化的人。
- 需要把 SEO 工作拆成可执行任务的人。
