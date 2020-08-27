### Demo1

控制方程为：
$$
\left \{ 
\begin{array}{c}
T\frac{\partial^2{H}}{\partial{x}^2}=\mu\frac{\partial{H}}{\partial{t}} \qquad 0\leqslant {x}\leqslant {1000} \\
H|_{t=0}=0.0 \\
H|_{x=0}=1.0 \qquad H|_{x=1000}=0.0
\end{array}
\right.
$$
其中：$T=20.0，\mu=0.002$，取$\Delta{x}=100.0，\Delta{t}=0.5， NP=11$

有限差分方程为，
$$
T\frac{H^t_{i-1}+H^t_{i+1}-2H^t_{i}}{\Delta{x}^2}=\mu\frac{H^{t+1}_{i}-H^{t}_{i}}{\Delta{t}}
$$
假设$\lambda = T\Delta{t}/(\mu{\Delta{x}^2})$
$$
H^{t+1}_{i} = H^{t}_{i}+\lambda({H^t_{i-1}+H^t_{i+1}-2H^t_{i}})
$$
