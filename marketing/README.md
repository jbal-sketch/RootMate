# RootMate Marketing Website

This folder contains the HTML marketing site for RootMate landing pages.

## Structure

```
marketing/
├── index.html              # Main landing page
├── pages/                  # Additional pages
│   ├── contact.html        # Contact page
│   ├── privacy.html        # Privacy policy
│   └── terms.html          # Terms of service
├── css/                    # Stylesheets
│   ├── styles.css          # Main styles
│   ├── contact.css         # Contact page styles
│   └── pages.css           # Generic page styles
├── js/                     # JavaScript files
│   ├── main.js             # Main JavaScript
│   └── contact.js          # Contact form handler
└── images/                 # Images and assets
    └── (add your images here)
```

## Features

- **Responsive Design**: Works on all devices (mobile, tablet, desktop)
- **Modern UI**: Clean, professional design with smooth animations
- **SEO Friendly**: Proper meta tags and semantic HTML
- **Fast Loading**: Optimized CSS and JavaScript
- **Accessible**: Follows web accessibility best practices

## Setup

1. Add your images to the `images/` folder:
   - `hero-app-preview.png` - App screenshot for hero section
   - `app-store-badge.svg` - App Store download badge

2. Customize the content:
   - Update text in `index.html`
   - Modify colors in `css/styles.css` (CSS variables)
   - Add your contact email and links

3. Deploy:
   - Upload to any web hosting service
   - Or use GitHub Pages, Netlify, Vercel, etc.

## Customization

### Colors
Edit the CSS variables in `css/styles.css`:
```css
:root {
    --primary-color: #2d5016;
    --secondary-color: #4a7c2a;
    --accent-color: #6b9f3d;
    /* ... */
}
```

### Contact Form
The contact form currently shows an alert. To make it functional:
1. Set up a backend API endpoint
2. Update `js/contact.js` to send form data to your API
3. Add proper error handling and loading states

## Browser Support

- Chrome (latest)
- Firefox (latest)
- Safari (latest)
- Edge (latest)
- Mobile browsers (iOS Safari, Chrome Mobile)

