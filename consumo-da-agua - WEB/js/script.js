function entrar() {
    window.location.href = "home.html";
}

function trocarTema() {
    document.body.classList.toggle("dark");

    let tema = document.getElementById("tema");

    if (document.body.classList.contains("dark")) {
        localStorage.setItem("tema", "dark");

        if (tema) {
            tema.classList.add("ativo");
        }
    } else {
        localStorage.setItem("tema", "light");

        if (tema) {
            tema.classList.remove("ativo");
        }
    }
}

if (localStorage.getItem("tema") == "dark") {
    document.body.classList.add("dark");

    let tema = document.getElementById("tema");

    if (tema) {
        tema.classList.add("ativo");
    }
}