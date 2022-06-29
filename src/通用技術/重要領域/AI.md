# AI 相關

## Deep learning

* 基本概念
    * Machine learning 的一種
        * 讓機器可以學習
        * 實際上，機器學習的目標就是在找一個 Function
            * ~= Looking for a Function
        * 語言辨識 - 找一個可以辨識語音 function
    * 接下來我們會準備一堆學習的 data
        * Training Data
            * 看到這張圖片，你應該說這是貓
            * 看到這張圖片，你應該說這是狗
    * Supervised learning
        * 從這堆 function 裡(a set of function)
        * 需要一個有效的演算法，找出最好的 function
    * Machine Learning 有三個 step
        * 定出一個 function set
        * goodness of function
        * 找最好的 function
    * Deep Learning
        * define a set of function
            * 就是 Neural Network
                * 由 Neuron 神經元所構成 (簡單的 function)
                    * 吃一個 vector 當 input，output 一個 scalar
                    * 內建一組參數(係數乘 weight + b)，再通過一個 Activataion function 得到 a
                        * 和 input 有關的稱為 weight
                        * b 就是 bias
                        * Activation function (以前用 Sigmoid function)
                            * 現在也不常用 Activation function
                * 成千上萬個 Neural
                    * 輸入輸出可以相連接，
                    * 人自己決定怎麼接
                * 排法
                    * Fully Connect Feedforward Network
                        * 最常用的方法，如果沒有其他好的創意的話，就用這個吧
                * 輸入是一個 vector，輸出是一個 vector
                * 當結構定好後，如果沒有 weight 和 bias，就是 a set of function

                * 最前面叫 Input Layer
                * 最後面叫 Output Layer
                * 中間叫 hidden layer (deep 代表中間有很多 hidden layer)

                * Softmax Layer
                    * 最後沒有 Activation function，而是用別的方式處理
                    * 輸出比較像機率
        * Example
            * 辨識數字
                * 輸入是圖片，機器看到的是數字，vector
                    * 16x16 的圖片就是長度為 256 的 vector
                * 希望輸出是十維的 vector，對應 1 到零的信心分數

                * 需要一個 function (不知道長什麼樣子)，但總之， Neural Nework 可以用來表示這個 function
                * 把 256 維的當成 input layer，output layer 設計成只有十維的 vector
                * 不管中間有多少個 hidden layers，都是可以當做手寫辨識的 function
                * 從這個 function set 找到最好的 function
                * 不過 function set 有很多種，決定好的 function set 是很重要的(因為有可能找不到好的 function)
                * 怎麼找 function set？沒有好的答案，所以要 Trial and Error
                    * 有沒有可能用學習自動產生？(這是很難的問題)

            * Training Data
                * 搜集資料
                * function 的好壞，由訓練教材決定

            * 需要一個數值表示 function 的好壞
                * 可能的方法：和目標的差距決定好壞，比如說剛的例子就是目標數字為 1，其他都是 0，然後算距離
                * 稱 loss
                * 越小越好
            * 如何找出最好的 best function 讓 loss 最小？ (第三步)
                * 很難，因為通常有上百萬個參數
                * Graident Descent
                    * 隨機選取初始參數值 (也有其他的方法，但效果不佳，所以現在主流仍是 random)
                    * 偏微正，降 w，偏微負，增 w。
                        * learning rate
                    * 不斷 repeat
                    * 問題是這樣不同初始，可能會有不同的結果，所以結果看人品
                        * 所以有人討厭這個結果
                        * 有一些方法可以避開這個結果
                            * 做多次
                            * 有時走大一點，有時走小一點
                        * 目前沒有一個方法可以找到絕對最好的 func
                * Backpropagation
                    * 其實和 Graident Descent 是一樣的東西
                    * 只是方便算的方式
                    * 其實不知道也沒差，反正有成打的 toolkit 都可以幫忙算

            * Deeper is Better?
                * 越深，performance 越好？
                * Universality Theorem
                    * 任何一個 continuous function 都可以用一層 function 表示
                        * 所以有人說這只是噱頭
                    * 有人刻意調成同數量參數做實驗
            * Modularization
                * 藉由模組化的概念，可以在只有比較少的 data 的情況下，把這個做好
                * 找長髮男、長髮女、短髮男、短髮女
                    * 但長髮男資料少，最後效果差
                * 找長髮和短髮，再男和女
                    * 效果好，要的資料變少
                * Deep => Modularization
        * TensorFlow or theano
            * Very flexible
            * Need some effor to learn
            * 可以做的事太多，太彈性，所以需要花時間學
        * Keras
            * Interface of TensorFlow or Theano
            * 太無腦
                1. define a set of function
                2. Step2: goodness of function
                3. pick the best function
* Lecture ii: Recipe of Deep Learning
    * Overfitting (第一步檢查)
        * Good Results on Training Data? Yes
        * Good results on Testing Data ? No
        * Training set 結果好，但 Testing Data 不好才叫 Overfitting
        * 如果連 Training set 都不好，那是沒 Train 好
        * 比如說 dropout 是對付 Overfitting 的情況，其他就不適合
    * 技巧(上課不教的)
        1. 挑一個好的 loss
            * Square Error, Cross Entropy, ...
            * 結果該實驗 Cross Entropy 效果較好(不同情形效果不同)
        2. Mini-batch
            * is faster
            * 用原始的方式，會平滑的朝目標前進，但用這個方式會震盪
            * 感覺不安
            * 原始要 See all example 要花時間, mini batch ，看完 batch 就會 update 參數，速度快，次數多，出了很多拳，總會中，比較快。
            * 有做平行運算的話，不一定是對的
            * 但神奇的是結果 mini-batch 可以給你比較好的 performance
            * 所以就算有強大的平行運算，也不要用 full batch
            * 原始的方式很容易跳進
            * shuffle the training data for each epoch
        3. New Activation function
            * 越多層，反而效果越差，這不是 Overfitting，因為 training data 也會發生
            * Vanishing Gradient Problem
                * 靠近 input 的 Graident 很小，靠近 output 的 Gradient 很大
                * output 結束了，input 還沒好，所以 output 其實是基於 random 的結果
                * network 越深，靠近 input 影響越小
                * 有一個方法是一層一層的 training 解決(在很深的地方用，但現在少用，常直接換 Activation func)
            * 現在常用 ReLU (Rectified Linear Unit)
                * Fast to compute
                * Biological reason
                * Infinite sigmoid with different bias
                * Handle Vanishing Gradient Problem
                * 效果像是有比較瘦長的 network
            * Maxout
                * Learnable activation function
                * 現在可以不用煩惱 Activation function
                * 因為 Maxout 可以認出 Activation function
                * ReLU is a speical cases of Maxout
        4. Learning Rates
            * 非常重要
            * Popular & Simple Idea: Reduce the learning rate by some factor every epoch
            * Adagrad 方法
                * Parameter dependent learning rate
            * Adagrad 只是一個例子，現在有一大堆方式
        5. Momentum
            * 問題：
                * plateau: 很慢 (小於 threshold)
                * saddle point (微分為 0)
                * local minima:
            * 加上物理慣性解決，理想，但不保證

        6. 把 Adagard + Momentum 加起來就是 adam
            * 這年頭，如果沒有什麼特別的 prefer 的話，可以用 adam
        7. 接下來，如果 training data 到了極限後，接下來要怎麼提高 testing data？
            * Panacea for Overfitting
                * Have more training data
                * Create more training data
                    * 如：手寫辨識，左移十五度、聲音加雜訊
            * Early Stopping
                * 因為性質不同，所以有可能 training set 的 loss 的越來越小，但 test 反而變大，所以可以提早停止
            * Weight Decay
                * prune out the useless link between neurons
            * Dropout
                * Deep learning 中特有的
                * 每一個 neuron 有 p% 的機率被丟掉
                * 變成比較瘦長的 network training
                * 每次 update 參數時，都做一次 sample
                * testing 不要 dropout
                    * if the fropout rate at training is p%, all the weight times (1-p%)
                * 網路上有各種解釋，很神秘
                * Dropout is a kind of ensemble
                    * 感覺好像有多個 network
                    * 參數共享，所以資料不會太少
                * Dropout 會讓 training set 變差
                * 據說 Dropout 加 Maxout 效果很好
* Lecture iii: Variants of Neural Networks
    * Convolutional Neural Network (CNN)
        * Why CNN for Image?
        * 針對影像的特性，特別設計的 structure
        * 特性
            1. Some patterns are much smaller than the whole image
            2. The same patterns appear in different regions
                * 不需要有重覆的 neuron
            3. Subsampling the pixels will not change the object
                * 丟掉部分 input 的資訊
        * 用我們對影像的了解，刻意減少參數的數量
        * Convolution => Max Pooling => Convolution => Max Polling (可以 repeat) .... Flatten
        * Convolution
            * Max Pooling
                * 越做越小，直到爽為止
    * Recurrent Neural Network (RNN)
        * 希望諤 Neural 要有記憶力
        * 1-of-N encoding
            * lexicon = {cat, dog, ...}
        * Long Short-term Memory (LSTM)
        * RNN-based network is not always easy to learn
        * gradient 可能會大可能會小
            * 這也是用 LSTM 的原因，可以解決 gradient vanishing 的問題
        * GRU
            * LSTM 的精簡版，有越來越廣泛使用的趨勢
* Lecture iv: Next Wave
    * Supervised Learning
        * New network structure
            * Ultra Deep Network
                * 加 shortcut
                * 等於在同一個 network 裡面加上不同深度的 network
                * e.g. Residual Network, Highway Network(自動決定層數)
        * Attention-based Model
            * 只專注在相關的東西，人的大腦有 filter，將有相關的東西拿出來
    * Reinforcement Learning
        * 有一個 Agent 和環境進行互動，Observation => Action =>  Reward
        * 根據 Reward 決定 Action
        * 差別
            * Supervised
                * Learning from teacher
                * 要做的行為，要人告訴我是好的還是壞
            * Reinforcement
                * Learning from critics
        * 有兩個特色
            * 要的是 Maximum reward (放棄短期益)
            * Action's action afftect the subsequent data it receives
    * Deep Reinforcement Learning
        * 中間用 Neural Network 表示的
    * Unsupervised Learning
        * Deep Dream
            * 決定圖片應該長什麼樣子
        * Deep Style
            * 用該畫風畫
    * Generating Images
        * Pixel Recurrent Neural Network
        * Variation Auto-encoder (VAE)
        * Generative Adversarial Network (GAN)

## Deepfakes

* [AI 换脸术「Deepfakes」8 年进化史](https://mp.weixin.qq.com/s/qTLBqbyItB_h1mOx_9Hzkg)
