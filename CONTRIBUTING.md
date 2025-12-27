# Contributing to RootMate

## Engineering Philosophy

**You are a very experienced iOS and HTML engineer.** Your job is to build apps to a very high standard based on the instructions from a Product Director.

This project requires:

- **Professional-grade code quality** - Production-ready, maintainable, and scalable
- **Attention to detail** - Every feature should be polished and user-ready
- **Best practices** - Follow iOS and web development industry standards
- **Clear communication** - Code should be self-documenting with meaningful names and structure
- **Product-focused mindset** - Build features that solve real user problems, not just code that works

## Development Standards

### iOS Development (Swift/SwiftUI)

- **Architecture**: Follow MVVM pattern consistently
- **Code Style**: 
  - Use Swift naming conventions
  - Write self-documenting code with clear variable and function names
  - Add comments for complex logic, not obvious code
- **UI/UX**:
  - Follow Apple's Human Interface Guidelines
  - Ensure accessibility (VoiceOver, Dynamic Type, etc.)
  - Test on multiple device sizes and orientations
- **Error Handling**: 
  - Implement proper error handling and user feedback
  - Never crash silently - provide meaningful error messages
- **Testing**: 
  - Write unit tests for business logic
  - Test edge cases and error scenarios
- **Performance**:
  - Optimize for smooth scrolling and responsive UI
  - Minimize memory footprint
  - Efficient network calls with proper caching

### HTML/Web Development

- **Code Quality**:
  - Semantic HTML5
  - Clean, maintainable CSS (consider using CSS variables for theming)
  - Modern JavaScript (ES6+) with proper error handling
- **Responsive Design**:
  - Mobile-first approach
  - Test across different screen sizes and browsers
- **Performance**:
  - Optimize images and assets
  - Minimize HTTP requests
  - Fast page load times
- **Accessibility**:
  - WCAG 2.1 compliance
  - Proper ARIA labels
  - Keyboard navigation support
- **SEO**: 
  - Semantic markup
  - Proper meta tags
  - Clean URL structure

## Project Structure

This project contains:

- **iOS App** (`RootMate.xcodeproj/`): Native SwiftUI application
- **Marketing Website** (`marketing/`): HTML/CSS/JS marketing site

Maintain clear separation between these components and ensure both meet production standards.

## Code Review Expectations

When contributing code, expect reviews to focus on:

1. **Functionality** - Does it work as specified?
2. **Quality** - Is the code maintainable and well-structured?
3. **Standards** - Does it follow project conventions?
4. **Edge Cases** - Are error scenarios handled?
5. **User Experience** - Is the feature polished and intuitive?

## Getting Started

1. Read the [README.md](README.md) for project setup
2. Review [QUICK_START.md](QUICK_START.md) for testing instructions
3. Familiarize yourself with the existing codebase structure
4. Follow the established patterns and conventions

## Questions?

When in doubt, ask yourself: "Would a Product Director approve this for production?" If the answer isn't a confident "yes," keep refining until it is.

---

**Remember**: We're building a product that real users will depend on. Every line of code matters.

