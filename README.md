# TMLPA-COA-PSO

Implementación y evaluación comparativa del **Algoritmo de Optimización del Coatí (COA)** frente a **Particle Swarm Optimization (PSO)** aplicados al **Problema de Localización de Microhubs y Asignación Peatonal (TMLPA)**.

Trabajo desarrollado en el marco del curso de la **Escuela de Ingeniería Civil Informática, Universidad de Valparaíso**.

**Autor:** Miguel Andrés Escobar Palta
**Año:** 2026

---

## Tabla de contenidos

1. [Descripción del proyecto](#1-descripción-del-proyecto)
2. [Estructura del repositorio](#2-estructura-del-repositorio)
3. [Requisitos](#3-requisitos)
4. [Instalación paso a paso](#4-instalación-paso-a-paso)
5. [Cómo replicar los experimentos](#5-cómo-replicar-los-experimentos)
6. [Cómo validar con MiniZinc](#6-cómo-validar-con-minizinc)
7. [Resumen de resultados](#7-resumen-de-resultados)
8. [Licencia](#8-licencia)

---

## 1. Descripción del proyecto

El **TMLPA** es una variante del problema de localización de hubs (de naturaleza NP-difícil) en la que se decide qué microhubs habilitar y a qué microhub asignar cada cliente, minimizando el costo total del sistema —compuesto por costos fijos de habilitación, costos operacionales y esfuerzo de desplazamiento peatonal ponderado por prioridad— sujeto a restricciones de capacidad, cobertura máxima de caminata y rango admisible de hubs habilitados.

Este proyecto:

- Implementa el algoritmo **COA** adaptado al espacio de soluciones del TMLPA.
- Lo compara contra una implementación de **PSO** como baseline metaheurístico.
- Valida la calidad de las soluciones contra el solver exacto **MiniZinc** en la instancia tratable.
- Aplica el test no paramétrico de **Wilcoxon signed-rank** para evaluar la significancia estadística de las diferencias observadas.

---

## 2. Estructura del repositorio

```
TMLPA-COA-vs-PSO/
├── README.md                  Este archivo
├── LICENSE                    Licencia MIT
├── .gitignore                 Archivos ignorados por git
├── requirements.txt           Dependencias de Python
├── notebooks/
│   ├── TMLPA-COATI.ipynb      Implementación y ejecución de COA
│   ├── TMLPA-PSO.ipynb        Implementación y ejecución de PSO
│   └── analisis.ipynb         Análisis comparativo y test de Wilcoxon
└── minizinc/
    ├── small.mzn              Modelo para la instancia pequeña
    ├── medium.mzn             Modelo para la instancia mediana
    └── README.md              Instrucciones para ejecutar en MiniZinc Playground
```

> **Nota:** Las figuras (curvas de convergencia, boxplots) y los archivos Excel con los resultados (`resultados_COA.xlsx`, `resultados_PSO.xlsx`) **se generan automáticamente** al ejecutar los notebooks. Por eso no están versionados en el repositorio.

---

## 3. Requisitos

- **Python 3.10 o superior** (el proyecto se desarrolló y probó con Python 3.14.4)
- **Jupyter** (Jupyter Notebook o JupyterLab, o bien la extensión de Jupyter para Visual Studio Code)
- **Navegador web** para acceder al MiniZinc Playground en `https://play.minizinc.dev/`

### Bibliotecas de Python

Las dependencias están listadas en `requirements.txt`:

```
numpy
matplotlib
openpyxl
scipy
```

Los módulos `math`, `random`, `time` y `statistics` son parte de la biblioteca estándar y no requieren instalación.

---

## 4. Instalación paso a paso

### 4.1. Clonar el repositorio

```bash
git clone https://github.com/PMeik/TMLPA-COA-PSO.git
cd TMLPA-COA-vs-PSO
```

### 4.2. (Recomendado) Crear un entorno virtual

**En Linux / macOS:**

```bash
python3 -m venv venv
source venv/bin/activate
```

**En Windows (PowerShell):**

```powershell
python -m venv venv
venv\Scripts\Activate.ps1
```

### 4.3. Instalar dependencias

```bash
pip install -r requirements.txt
```

### 4.4. Verificar instalación

```bash
python -c "import numpy, matplotlib, openpyxl, scipy; print('OK')"
```

Si imprime `OK`, todo está listo.

---

## 5. Cómo replicar los experimentos

Cada notebook está diseñado para ejecutarse **de principio a fin sin intervención manual**. Los parámetros (tamaño de población, número de iteraciones, número de corridas) ya están configurados con los valores reportados en el informe.

### 5.1. Ejecutar COA

```bash
jupyter notebook notebooks/TMLPA-COATI.ipynb
```

Y en la interfaz de Jupyter:
- **Cell → Run All**

Esto ejecutará COA sobre las tres instancias (Small, Medium y Big), con 40 corridas por instancia, generando:

- Las **curvas de convergencia** y **boxplots** mostrados al final del notebook.
- El archivo **`resultados_COA.xlsx`** con los historiales completos y los estadísticos descriptivos.

### 5.2. Ejecutar PSO

```bash
jupyter notebook notebooks/TMLPA-PSO.ipynb
```

Y nuevamente **Cell → Run All**.

Genera análogamente **`resultados_PSO.xlsx`**.

### 5.3. Ejecutar el análisis comparativo

```bash
jupyter notebook notebooks/analisis.ipynb
```

Este notebook **requiere que los dos archivos Excel anteriores ya existan** en la misma carpeta. Carga los resultados de ambos algoritmos, genera los gráficos comparativos COA vs PSO y aplica el test de Wilcoxon signed-rank.

### 5.4. Tiempos esperados

A modo de referencia, sobre una máquina estándar:

| Notebook | Tiempo total aproximado |
|---|---|
| `TMLPA-COATI.ipynb` | ~75 minutos (40 corridas × 3 instancias) |
| `TMLPA-PSO.ipynb` | ~135 minutos (40 corridas × 3 instancias) |
| `analisis.ipynb` | < 1 minuto |

> **Tip:** si solo quieres una verificación rápida, edita la celda de configuración del notebook y reduce el número de corridas a 5–10. Los resultados no serán estadísticamente robustos, pero te permitirán comprobar que el pipeline funciona.

### 5.5. Reproducibilidad

Cada corrida `k` utiliza la semilla `seed = k` (con `k ∈ {1, …, 40}`). Esto garantiza que cualquier persona que clone el repositorio obtenga **exactamente los mismos resultados** reportados en el informe, y permite la comparación pareada COA vs PSO requerida por el test de Wilcoxon.

---

## 6. Cómo validar con MiniZinc

Los modelos MiniZinc (`small.mzn` y `medium.mzn`) están diseñados para ejecutarse en el **MiniZinc Playground** oficial, sin requerir instalación local.

**Pasos:**

1. Abrir [https://play.minizinc.dev/](https://play.minizinc.dev/) en el navegador.
2. Abrir el archivo `minizinc/small.mzn` (o `medium.mzn`) de este repositorio.
3. Copiar todo el contenido y pegarlo en el editor del Playground.
4. Hacer clic en **Run**.

Ver `minizinc/README.md` para más detalles, incluyendo los resultados esperados y notas sobre la escalabilidad.

---

## 7. Resumen de resultados

Resultados obtenidos sobre 40 corridas por instancia. La función objetivo corresponde al costo total del sistema (menor es mejor).

| Instancia | Algoritmo | Promedio | Mediana | Desv. Est. | Tiempo prom. (s) |
|---|---|---|---|---|---|
| Small (5×3) | COA | 76.90 | 76.90 | 0.00 | 3.44 |
| Small (5×3) | PSO | 76.90 | 76.90 | 0.00 | 3.55 |
| Medium (50×10) | COA | 930.74 | 932.75 | 8.14 | 47.09 |
| Medium (50×10) | PSO | 920.08 | 921.30 | 8.60 | 101.36 |
| Big (100×20) | COA | 1921.43 | 1921.35 | 16.15 | 62.13 |
| Big (100×20) | PSO | 1875.59 | 1877.25 | 18.54 | 197.09 |

**Test de Wilcoxon signed-rank** (α = 0.05):

| Instancia | W | p-valor | Resultado |
|---|---|---|---|
| Small | — | — | No aplica (empate perfecto) |
| Medium | 96.00 | 2.44 × 10⁻⁵ | PSO significativamente mejor |
| Big | 0.00 | 1.82 × 10⁻¹² | PSO significativamente mejor |

**Observación:** PSO obtiene mejor calidad de solución, COA es entre 2 y 3 veces más rápido en tiempo de ejecución. El detalle de la discusión y las implicancias del trade-off se encuentran en el informe asociado al proyecto.

---

## 8. Licencia

Este proyecto se distribuye bajo licencia **MIT**. Ver `LICENSE` para más detalles.

---

## Contacto

Para consultas sobre el proyecto, dirigirse a miguel.escobar.palta@gmail.com
