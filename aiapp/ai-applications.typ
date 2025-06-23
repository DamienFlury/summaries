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

= Reinforcement Learning
Reinforcement learning is its own branch of ML and is also called behavioural learning.
The agent's goal is to select those actions which maximize the long term reward.
Idea: "Trial and error", the agent starts with random actions. It has a wide field of applications.

== Limitations
- Computation heavy, thousands of simulation hours
- Defining reward function is difficult

== Markov Decision Process (MDP)
- *S*: Set of states ${ S_0, ..., S_7 }$
- *A*: Set of actions ${ a_0, a_1 }$
- *R*: The (positive and negative) rewards
- *P*: The transitions / set of transition probabilities

The agent:
- interacts with the environment
- is hedonic (tries to maximize its reward)
- Learns an optimal behaviour

The behaviour of an agent is fully defined by its *policy $pi$*.
$pi$ is a function that maps states to action-selection-probabilities, e.g.
$pi(s=53, a="left") = 0.76$. There are infinite policies, an RL agent typically starts with a random one.
#figure(
  image("assets/rl-framework.png", width: 80%),
  caption: [General RL framework],
) <fig-rl-framework>

Optimally we want to choose for each state $S_t$ the action $A_t$ which returns the
largest *sum of (discounted) rewards*.

- $pi^*$: Optimal policy (if the agent knows the full MPD)

== Discount factor $gamma$
The shorter path to the same reward is usually preferable. We discount rewards
that are far away. The real world is full of risks, will the reward still be
there? In mechanics each step of the machine has a risk of failure.

Discounting is applied when comparing *future* rewards. When the agent actually
lands in a state, he gets the full reward $R$ (not $lambda R$)

#figure(
  image("assets/discounted-rewards.png", width: 80%),
  caption: [Discounted rewards],
) <fig-discounted-rewards>

== Return G
- Discounted sum of future rewards
$
G_t = R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.h.c
= sum_(k=0)^infinity gamma^k R_(t + k + 1)
$ 

== State-action value $Q(s, a)$
The state-action value $Q^pi(s, a)$ is the expected Return $G$, when starting in state $s$, taking action $a$ and following the policy $pi$ thereafter. 

The goal of many RL algorithms is to estimate these q-values.
