let registros = [];
let editando = -1;
let grafico = null;

let dados = localStorage.getItem("registrosAgua");

if (dados != null) {
    registros = JSON.parse(dados);
}

function trocarTema() {
    document.body.classList.toggle("dark");

    if (document.body.classList.contains("dark")) {
        localStorage.setItem("tema", "dark");
    } else {
        localStorage.setItem("tema", "light");
    }
}

if (localStorage.getItem("tema") == "dark") {
    document.body.classList.add("dark");
}

function abrirModal() {
    editando = -1;

    document.getElementById("tituloModal").innerText =
        "Novo consumo";

    limparCampos();

    document.getElementById("modal").classList.add("ativo");
}

function fecharModal() {
    document.getElementById("modal").classList.remove("ativo");

    limparCampos();
}

function salvarAgua() {
    let data = document.getElementById("data").value;
    let quantidade =
        Number(document.getElementById("quantidade").value);
    let peso =
        Number(document.getElementById("peso").value);

    if (
        data == "" ||
        quantidade <= 0 ||
        peso <= 0
    ) {
        alert("Preencha todos os campos!");
        return;
    }

    let registro = {
        data: data,
        quantidade_em_ml: quantidade,
        peso_atual_kg: peso
    };

    if (editando == -1) {
        registros.push(registro);
    } else {
        registros[editando] = registro;
    }

    localStorage.setItem(
        "registrosAgua",
        JSON.stringify(registros)
    );

    fecharModal();
    mostrarRegistros();
}

function mostrarRegistros() {
    let lista = document.getElementById("listaAgua");

    if (!lista) {
        return;
    }

    lista.innerHTML = "";

    if (registros.length == 0) {
        lista.innerHTML = `
            <div class="caminhada">
                <div>
                    <h3>Nenhum consumo cadastrado</h3>
                    <p>Adicione seu primeiro registro.</p>
                </div>
            </div>
        `;

        atualizarResumo();
        criarGrafico();

        return;
    }

    for (let i = 0; i < registros.length; i++) {
        let item = registros[i];

        lista.innerHTML += `
            <div
                class="caminhada"
                onclick="editarAgua(${i})"
            >

                <div>

                    <h3>
                        ${item.quantidade_em_ml} ml
                    </h3>

                    <p>
                        ${formatarData(item.data)}
                    </p>

                    <div class="dados-caminhada">

                        <p>
                            Peso: ${item.peso_atual_kg} kg
                        </p>

                    </div>

                </div>

                <div class="calorias">

                    <strong>
                        ${calcularPorcentagemItem(item)}%
                    </strong>

                    <small>
                        da meta diária
                    </small>

                    <button
                        class="excluir"
                        onclick="
                            event.stopPropagation();
                            excluirAgua(${i});
                        "
                    >
                        Excluir
                    </button>

                </div>

            </div>
        `;
    }

    atualizarResumo();
    criarGrafico();
}

function editarAgua(i) {
    let item = registros[i];

    editando = i;

    document.getElementById("tituloModal").innerText =
        "Editar consumo";

    document.getElementById("data").value = item.data;
    document.getElementById("quantidade").value =
        item.quantidade_em_ml;
    document.getElementById("peso").value =
        item.peso_atual_kg;

    document.getElementById("modal").classList.add("ativo");
}

function excluirAgua(i) {
    if (confirm("Deseja excluir este registro?")) {
        registros.splice(i, 1);

        localStorage.setItem(
            "registrosAgua",
            JSON.stringify(registros)
        );

        mostrarRegistros();
    }
}

function limparCampos() {
    document.getElementById("data").value = "";
    document.getElementById("quantidade").value = "";
    document.getElementById("peso").value = "";
}

function formatarData(data) {
    if (data == "") {
        return "";
    }

    let partes = data.split("-");

    return partes[2] + "/" +
        partes[1] + "/" +
        partes[0];
}

function metaDiaria(peso) {
    return peso * 35;
}

function calcularPorcentagemItem(item) {
    let meta = metaDiaria(
        Number(item.peso_atual_kg)
    );

    if (meta <= 0) {
        return 0;
    }

    return (
        Number(item.quantidade_em_ml) /
        meta *
        100
    ).toFixed(1);
}

function atualizarResumo() {
    let hoje = new Date();

    let dataHoje =
        hoje.getFullYear() + "-" +
        String(hoje.getMonth() + 1).padStart(2, "0") + "-" +
        String(hoje.getDate()).padStart(2, "0");

    let total = 0;
    let peso = 0;

    for (let item of registros) {
        if (item.data == dataHoje) {
            total += Number(item.quantidade_em_ml);
            peso = Number(item.peso_atual_kg);
        }
    }

    let meta = metaDiaria(peso);

    let porcentagem = 0;

    if (meta > 0) {
        porcentagem = total / meta * 100;
    }

    document.getElementById("totalAgua").innerText =
        total.toFixed(0) + " ml";

    document.getElementById("metaAgua").innerText =
        meta.toFixed(0) + " ml";

    document.getElementById("porcentagemMeta").innerText =
        porcentagem.toFixed(1) + "%";
}

function criarGrafico() {
    let canvas = document.getElementById("grafico");

    if (!canvas) {
        return;
    }

    if (grafico != null) {
        grafico.destroy();
    }

    let nomes = [];
    let quantidades = [];

    for (let item of registros) {
        nomes.push(
            formatarData(item.data)
        );

        quantidades.push(
            Number(item.quantidade_em_ml)
        );
    }

    grafico = new Chart(canvas, {
        type: "bar",

        data: {
            labels: nomes,

            datasets: [
                {
                    label: "Consumo em ml",
                    data: quantidades
                }
            ]
        },

        options: {
            responsive: true,
            maintainAspectRatio: false
        }
    });
}

mostrarRegistros();