== Conv2D
$
"Output.x" = ("Input.x" - "Kernel.x") / "Stride" + 1
$
== MaxPool2D
$
"Output.x" = ("Input.x" + 2 * "Padding" - "Kernel.x") / "Stride.x" + 1
$

= Softmax
$
S(y)_i = exp(y_i) / (sum_(j=1)^n exp(y_j))
$

= Sparse categorical crossentropy loss
$L("input", "label", theta, lambda) = 1.234$
Loss is calculated using the input data, the label, all network parameters
$theta$ and regularization parameters $lambda$.

== Back-Propagation
$omega_345 = omega_345 - alpha dot (diff L)/(diff omega_345)$

= regularization
== Dropout-method
Dropout is a simple regularization method.
In TF: `tf.keras.layers.dropout(0.2)`.

#figure(
  image("assets/dropout-method.png", width: 80%),
  caption: [Dropout method],
) <fig-dropout-method>

Dropout isn't the same as ensemble, but has similarities.

== L2 Weights Penalty
$
L' = L + lambda sum_i omega_i^2
$

`kernel_regularizer=
tf.keras.regularizers.l2(0.001)`

= Autoencoder
We compress an image. The network should learn a very compact representation of
the image. The feature vector that results from the compression should be as
low-dimensional as possible.

It is used for denoising images.

= Classifying audio input
1. Transform audio into spectrogram (using FFT)
2. Spectrogram is like an image $->$ CNN!
