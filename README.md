# Keepstore SEO Growth Desk

这是一个面向 SEO 零基础用户的 Keepstore.com 独立站 SEO 诊断与优化工作台。新版网站强化了产品设计、页面截图式定位、问题优先级、页面改法模板、90 天路线图和可交互验收清单。

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

- `index.html`：网站主体内容，包含 SEO 工作台、截图式页面定位图、问题库、页面改造模板、90 天路线图和互动清单。
- `styles.css`：视觉系统、响应式布局、仪表盘、截图切换、问题卡片、路线图和清单样式。
- `script.js`：移动端菜单、截图式定位图切换、问题筛选、互动清单进度计算。
- `assets/page-shots/*.svg`：基于公开抓取内容制作的截图式定位图，用于帮助用户定位独立站页面上的具体问题。
- `.github/workflows/github-pages.yml`：GitHub Pages 自动部署工作流。

## 截图说明

当前仓库里的 `assets/page-shots/*.svg` 是“截图式定位图”：它们基于 Keepstore 公开页面抓取内容复刻关键区域，并用红/蓝/绿标注问题位置。这样即使读者不懂 SEO，也能快速理解问题出现在首页、产品页、集合页、博客页还是技术配置里。

如果后续拿到了真实浏览器截图，可以直接用同名 PNG/JPG 替换这些 SVG，并在 `index.html` 中更新图片路径。

## 适合谁看

- 完全不懂 SEO 的运营、老板、市场同学。
- 不懂代码但需要推动 Shopify / 独立站优化的人。
- 需要把 SEO 工作拆成可执行任务的人。
