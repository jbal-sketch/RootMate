// Contact Form Handler
document.addEventListener('DOMContentLoaded', function() {
    const contactForm = document.getElementById('contactForm');
    
    if (contactForm) {
        contactForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = {
                name: document.getElementById('name').value,
                email: document.getElementById('email').value,
                subject: document.getElementById('subject').value,
                message: document.getElementById('message').value
            };
            
            // Here you would typically send this to a server
            // For now, we'll just show a success message
            console.log('Form submitted:', formData);
            
            // Show success message
            alert('Thank you for your message! We\'ll get back to you soon.');
            
            // Reset form
            contactForm.reset();
            
            // In a real application, you would:
            // 1. Send the data to your backend API
            // 2. Handle errors appropriately
            // 3. Show loading states
        });
    }
});

