"use strict";

// Fix back button cache problem
window.onunload = function () { };

(function theme() {
    var html = document.querySelector("html");
    var themeToggleButton = document.getElementById("theme-toggle");

    themeToggleButton.addEventListener('click', function sidebarToggle() {
        if (html.classList.contains("void-light")) {
            html.classList.replace("void-light", "void-dark");
            localStorage.setItem('mdbook-theme', "void-dark");
        } else {
            html.classList.replace("void-dark", "void-light");
            localStorage.setItem('mdbook-theme', "void-light");
        }
    });
})();

(function sidebar() {
    var body = document.querySelector("body");
    var sidebar = document.getElementById("sidebar");
    var sidebarLinks = document.querySelectorAll('#sidebar a');
    var sidebarToggleButton = document.getElementById("sidebar-toggle");
    var sidebarResizeHandle = document.getElementById("sidebar-resize-handle");
    var firstContact = null;

    function showSidebar() {
        body.classList.remove('sidebar-hidden')
        body.classList.add('sidebar-visible');
        Array.from(sidebarLinks).forEach(function (link) {
            link.setAttribute('tabIndex', 0);
        });
        sidebarToggleButton.setAttribute('aria-expanded', true);
        sidebar.setAttribute('aria-hidden', false);
        try { localStorage.setItem('mdbook-sidebar', 'visible'); } catch (e) { }
    }

    function hideSidebar() {
        body.classList.remove('sidebar-visible')
        body.classList.add('sidebar-hidden');
        Array.from(sidebarLinks).forEach(function (link) {
            link.setAttribute('tabIndex', -1);
        });
        sidebarToggleButton.setAttribute('aria-expanded', false);
        sidebar.setAttribute('aria-hidden', true);
        try { localStorage.setItem('mdbook-sidebar', 'hidden'); } catch (e) { }
    }

    // Toggle sidebar
    sidebarToggleButton.addEventListener('click', function sidebarToggle() {
        if (body.classList.contains("sidebar-hidden")) {
            var current_width = parseInt(
                document.documentElement.style.getPropertyValue('--sidebar-width'), 10);
            if (current_width < 150) {
                document.documentElement.style.setProperty('--sidebar-width', '150px');
            }
            showSidebar();
        } else if (body.classList.contains("sidebar-visible")) {
            hideSidebar();
        } else {
            if (getComputedStyle(sidebar)['transform'] === 'none') {
                hideSidebar();
            } else {
                showSidebar();
            }
        }
    });

    sidebarResizeHandle.addEventListener('mousedown', initResize, false);

    function initResize(e) {
        window.addEventListener('mousemove', resize, false);
        window.addEventListener('mouseup', stopResize, false);
        body.classList.add('sidebar-resizing');
    }
    function resize(e) {
        var pos = (e.clientX - sidebar.offsetLeft);
        if (pos < 20) {
            hideSidebar();
        } else {
            if (body.classList.contains("sidebar-hidden")) {
                showSidebar();
            }
            pos = Math.min(pos, window.innerWidth - 100);
            document.documentElement.style.setProperty('--sidebar-width', pos + 'px');
        }
    }
    //on mouseup remove windows functions mousemove & mouseup
    function stopResize(e) {
        body.classList.remove('sidebar-resizing');
        window.removeEventListener('mousemove', resize, false);
        window.removeEventListener('mouseup', stopResize, false);
    }

    document.addEventListener('touchstart', function (e) {
        firstContact = {
            x: e.touches[0].clientX,
            time: Date.now()
        };
    }, { passive: true });

    document.addEventListener('touchmove', function (e) {
        if (!firstContact)
            return;

        var curX = e.touches[0].clientX;
        var xDiff = curX - firstContact.x,
            tDiff = Date.now() - firstContact.time;

        if (tDiff < 250 && Math.abs(xDiff) >= 150) {
            if (xDiff >= 0 && firstContact.x < Math.min(document.body.clientWidth * 0.25, 300))
                showSidebar();
            else if (xDiff < 0 && curX < 300)
                hideSidebar();

            firstContact = null;
        }
    }, { passive: true });
})();

(function chapterNavigation() {
    document.addEventListener('keydown', function (e) {
        if (e.altKey || e.ctrlKey || e.metaKey || e.shiftKey) { return; }
        if (window.search && window.search.hasFocus()) { return; }
        var html = document.querySelector('html');

        function next() {
            var nextButton = document.querySelector('.nav-chapters.next');
            if (nextButton) {
                window.location.href = nextButton.href;
            }
        }
        function prev() {
            var previousButton = document.querySelector('.nav-chapters.previous');
            if (previousButton) {
                window.location.href = previousButton.href;
            }
        }
        switch (e.key) {
            case 'ArrowRight':
                e.preventDefault();
                if (html.dir == 'rtl') {
                    prev();
                } else {
                    next();
                }
                break;
            case 'ArrowLeft':
                e.preventDefault();
                if (html.dir == 'rtl') {
                    next();
                } else {
                    prev();
                }
                break;
        }
    });
})();
