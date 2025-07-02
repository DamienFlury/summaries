#import "@preview/lovelace:0.3.0": *

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
- Follows a predefined path
$
G_t = R_(t+1) + gamma R_(t+2) + gamma^2 R_(t+3) + dots.h.c
= sum_(k=0)^infinity gamma^k R_(t + k + 1)
$ 

== State-action value $Q(s, a)$
The state-action value $Q^pi(s, a)$ is the expected Return $G$, when starting in state $s$, taking action $a$ and following the policy $pi$ thereafter. 

The goal of many RL algorithms is to estimate these q-values.

State-action values don't follow a predefined path. They follow a policy $pi$ and
have an initial action $a$.

$
Q(s,a) = EE[G | s, a]
$

The expected value $EE[X]$ can be approximated by doing samples and calculating
the mean.

$
Q(s_t, a_t) &= EE[gamma^0 R_(t + 1) + gamma^1 R_(t + 2) + gamma^2 R_(t + 3) + dots.h.c] \
&= EE[gamma^0 R_(t + 1)] + EE[gamma^1 R_(t + 2) + gamma^2 R_(t + 3) + dots.h.c] \
&= EE[gamma^0 R_(t + 1)] + gamma EE[R_(t + 2) + gamma^1 R_(t + 3) + dots.h.c] \
&= EE[gamma^0 R_(t + 1)] + gamma Q(s_(t + 1), a_(t + 1))
$

== Temporal Difference
$
Q(s_t, a_t) = EE(gamma^0 R_(t + 1)) + gamma Q(s_(t + 1), a_(t + 1)) \
Q(s_t, a_t) + delta_t = gamma^0 r_(t + 1) + gamma Q(s_(t + 1), a_(t + 1)) \
$
$r_(t + 1)$ is the concrete outcome, not an expected value! Therefore $r_(t +
1) != EE(R_(t+1))$ in the general case. If we have a fair die, $r_(t + 1)$ for
example could be 3, but $EE(R_(t + 1))$ is 3.5. Therefore we introduce this
$delta_t$ to make the equation correct.

$
underbrace(delta_t, "Reward prediction error (RPE)") = r_(t + 1) + gamma Q(s_(t + 1), a_(t + 1)) - Q(s_t, a_t)
$

== V-Values
The V values are the *expected* return (sum of rewards) under the policy $pi$
and at the state $S$.

We start at the leaves and calculate V recursively back to the node we're
interested in.

== SARSA (State-action-reward-state-action)
$
"RPE"_t = r_(t + 1) + gamma Q^pi (s_(t + 1), a_(t + 1)) - Q^pi (s_t, a_t) \
Q^pi (s_t, a_t) <- Q^pi (s_t, a_t) + alpha "RPE"_t
$

#pseudocode-list[
+ Initialize $Q(s, a), forall s in S, a in A(s)$, arbitrarily, and $Q("last state", dot) = 0$
+ For each episode:
  + Initialize $S$
  + Choose $A$ from $S$ using Policy derived from $Q$ (e.g. $epsilon$-greedy)
  + For each step of episode:
    + Take action $A$, observe $R, S'$
    + Choose $A'$ from $S'$ using policy derived from $Q$ (e.g. $epsilon$-greedy)
    + $Q(S, A) <- Q(S, A) + alpha [R + gamma Q(S', A') - Q(S, A)]$
    + $S <- S'$
    + $A <- A'$
  + until S is last state
]

=== Q-Learning
Q-Learning is a variation of SARSA. Instead of already choosing $A'$ from $S'$
(Line 7), we take the max:
#pseudocode[$Q(S, A) <- Q(S, A) + alpha [R + gamma max_a Q(S', a) - Q(S, A)]$]
The next Action we take (in the next iteration) however still follows our
policy, so might be different (off-policy)! SARSA is *on-policy*, Q-Learning is
*off-policy*.

== Exploration-Exploitation Dilemma
At first, the agent doesn't know any rewards. At some point however, the agent
may start to follow the most promising path and collect more reward $->$ Agent
*exploits* its knowledge. A behaviour which always exploits the best available
action is called a *greedy policy*. A greedy policy stops to explore and may
fail to find the best trajectory. We need to find a balance.

We can start with a random policy to explore the entire environment and to
estimate the values.

At a later point we could switch from the random policy to the other extreme, greedy policy.

== Policies

=== The epsilon greedy policy
The $epsilon$-greedy policy balances between exploration and exploitation.
At each state:
- with probability $1 - epsilon$: Take the 'best' action, exploit
- with probability $epsilon$: Take a random action, explore
We could for example start with $epsilon = 0.95$ and reduce it over time.

==== Determining $epsilon$
Example:
$
Q(s,\_) = vec(6.5, 1.4, 6.9) -> pi(s,\_) = vec(0.1, 0.1, 0.8)
$
- Probability of greedy action: $1 - epsilon + epsilon/n$
- Probability of non-greedy action: $epsilon/n$

=== The softmax policy
- Alternative to epsilon-greedy
$
pi(s,a) = exp(Q(s,a)/T)/(sum_accent(a,tilde) exp(Q(s, accent(a, tilde))/T))
$


= Deep Reinforcement Learning (DRL)
RL with a table doesn't scale:
- Chess
- Go
- ...

== Disadvantages of tables
- Doesn't scale
- Limited to discrete state/actions
- No generalization:
  - What does entry at (S3000, a5) tell us about (S3001, a5)? Nothing.
- In real control processes:
  - Nearby states often have similar Q-Values
  - In similar states it is reasonable to choose similar or the same actions

== Idea
Q is just a function from (state, action) to Q(state, action). We can use any
function that is optimizable and that generalizes well and then approximate
this function.

In DRL we use a deep neural network to approximate the Q-values.
- Input: The state $s$ (e.g. RGB image, state of chess board)
- Output: One Output neuron per action a. The neuron's activity (=output) is
  $approx Q(s,a)$

== DQN: Loss
$
L_i(theta_i) = EE_((s,a,r,s') tilde U(D))[(r + gamma max_(a')Q(s', a', theta_i^-) - Q(s,a, theta_i))^2]
$
- $theta$ vs $theta^-$: Two neural networks with different parameters $theta$ (resp. $theta^-$).

== Replay Buffer
Different experiences are saved in a replay buffer. We then pick a few
experiences at random from the replay buffer and do a forward- and
backward-pass to train the neural network on this batch of samples.


#figure(
  image("assets/replay-buffer.png", width: 60%),
  caption: [Replay Buffer],
) <fig-replay-buffer>

== Actor-Critic
Two neural networks, an actor and a critic which evaluates the decisions of the
actor and gives feedback.

= Sequential data
== Time series data
- special type of sequential data
- Index ("x-axis") is time
- For example:
  - Stock option pricing
  - Sensor data (IoT)
  - Weather data

== Prediction
- Predictions are made based on historic data
- Look for structure/patterns:
  - Seasonality (e.g. higher solar energy production in summer than in winter)
  - Trends (long term increase/decrease)
- Sometimes, deep learning approach is faster, more accurate than complex mathematical models:
  - Weather data can be analyzed and extrapolated using deep learning.
    Mathematical models are computationally intensive and do not learn from
    past weather patterns

Text is sequential data too! E.g. LLM next word prediction. LLMs generate a text sequence based on the input sequence (sequence to sequence).

Words in an LLM are first turned into tokens, the resulting numbers are then
mapped onto vectors (embedding).

== Examples for Sequential data
- Forecasting traffic
- Text generation
- Anomaly detection (Network traffic)

== Applications
- Many to one:
  - "Worst movie ever" $->$ negative
- One to many:
  - Picture of a girl in a pink dress $->$ "Girl in a pink dress"
- Many to many:
  - "Worst movie ever" $->$ "Schlechtester Film aller Zeiten"

== Why ANNs don't work
FFNNs are unable to capture the temporal order of a time series, since they
treat each input independently.

CNNs are partially good for it. They can match patterns of series of data (one
dimensional for time series instead of two dimensional for images). However,
convolution will "fire" for both "This is a *very good idea*" and "not a *very
good idea*". CNNs are good at classification tasks. Convolutions and pooling
lose information about the local order of words.

== RNN concept

On the right we see the idea. The box is the same instead of being different on
each input.

One function calculates $h_t$, another function calculates $hat(y)_t$
#figure(
  image("assets/recurrence.png", width: 80%),
  caption: [Recurrence],
) <fig-recurrence>


#figure(
  image("assets/simple-rnn.png", width: 80%),
  caption: [simpleRNNCell (Keras)],
) <fig-simple-rnn>
$->$ Matrix multiplication.

=== Exploding Gradient Problem
- As the backpropagation-through-time (BPTT) algorithm advances backwards, the
  gradients can get larger and larger $->$ Gradient descent never converges

=== Vanishing Gradient Problem
As the backpropagation algorithm advances backwards, gradients often get
smaller and smaller $->$ Gradient eventually approaches 0, harder and harder to
propagate errors from the loss back to distant past $->$ RNN only learns short
term dependencies.


== Calculation of an RNN
=== Weights
- $d$: Input dimension
- $u$: Output dimension
- $b$: biases, one per unit
$
"weights" = "units" times (d + u + b)
$
