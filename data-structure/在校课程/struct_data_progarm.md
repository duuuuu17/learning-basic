# Struct Data

## First：链表

### 链表的结构体

```c++
#define elemtype int;
typedef struct link_table{
    elemtype data;
    link_table * next;
}link_table, *head
```

### 初始化

```
void init_lt(head &L){//该初始化会构建一个头结点
	L = new linktable;
    L->next = NULL;
}
```

### 链表元素的插入

因为是链表所以会使用指针

先声明一个新节点 ,并返回该新节点地址
```c++
link_table *n= new link_table; 
```
#### 前插法:

```c++
head; //链表的头结点地址
n->next = head->next;//先将新节点的后继赋为原链表的首元结点
head->next = head//将新结点移至头结点后，称为新的首元结点
```



#### 尾插法：

```C++
tail; //链表的尾结点地址
tail->next = n->next;//先将新节点的前驱赋为原链表的尾结点
n->next = ^//将新结点的后继变为尾结点，即为空^
```

### 树

### 二叉树层序遍历

使用两个队列，一个为存子树地址队列node_q，一个是存储子树值的队列data_q，根据data_q是否为空，来决定是否停止循环，其循环体为，根据node_q的左右子树是否为空，来选择入队其子树地址（是为了访问它的下一个子结点）和值（是为了访问它下一个子结点时，进行输出它的值)。

```c++
//层序遍历，利用后序遍历将同层元素压栈
void  push_layer_LRD(BTS_root root) {
	queue<BTS_root> node;//创建存储树节点地址的队列
	queue<int> q;//创建存储树节点值的队列
	if (root == NULL) return;
	q.push(root->data);//将根结点地址入队
	node.push(root);//将根结点值入队
	while (!q.empty()) {
		//当前存储指针队列的头结点的左孩子和右孩子，若不为空，则存储其child的值和地址
		if (node.front()->left != NULL) {
			q.push(node.front()->left->data);
			node.push(node.front()->left);
		}
		if (node.front()->right != NULL) {
			q.push(node.front()->right->data);
			node.push(node.front()->right);
		}
		cout << q.front() << endl;
		q.pop();//将根结点值出队
		node.pop();//将根结点地址出队

	}
}
```

### 霍夫曼编码

$$
Huffman\_tree\_matrix = 
\left[\begin
{array}{cccc}
weight&parent\_node&lchild&rchild\\
\hline
weight_1&parent\_node_1&lchild_1&rchild_1\\
\vdots &\vdots&\vdots&\vdots&\vdots\\
weight_n&parent\_node_n&lchild_n&rchild_n
\end{array}\right]
$$



```python
'''
contact为输入字符串
先统计顶点元素值vertex,然后使用vertex统计每个顶点的对应weigth
'''
import torch
vertex = torch.tensor(contact).unique()
weight = [contact.count(i) for i in vertex]
```

#### 实现

```python
import copy
import numpy as np
import torch

class Huffmantree_encode:
    """
    哈夫曼树，Cqupt-data_struct's lecture
    """

    def __init__(self):
        """
        初始化哈夫曼树，并构建起具有全局作用域的顶点集vertex和权值集weight(list)
        """

        '输入英文文字符'
        filepath = input("请输入英文字符串:\n")
        '将英文字符转为ASCII码'
        self.contact = [ord(i) for i in filepath]

        'vertex为统计字符串中出现的字符'
        self.vertex = torch.tensor(self.contact)
        self.vertex = self.vertex.unique()
        print(f"树节点{[chr(i) for i in self.vertex]}")

        'weight为每个字符的对应权值'
        self.weight = [self.contact.count(i) for i in self.vertex]
        print(f"对应节点权值{self.weight}")

        '构建哈夫曼树'
        self.huffman_t = self.create_Huffman()

        '构建编码'
        self.encode = self.encode()


    def minweight(self,weight_t):
        """
        寻找所剩节点最小节点
        利用numpy的argmin查找最小元素位置,当找到最小值的位置时，将返回，并且在weight列表中赋值为-1
        """

        weight_t = np.array(weight_t)
        '在使用argmin()函数前，给予前置条件（即过滤掉已组成的节点)'
        d_value = weight_t[weight_t > 0].min()
        weight_t = weight_t.tolist()

        return weight_t.index(d_value)


    def create_Huffman(self):
        """
        哈夫曼树结构：
        huffman_matrix:
        [
            [weight:Maxweight(visited), parent:-1(None), lchild:0(None), rchild:0(None)]
            lchild > rchild
            # huffman_t = [[chr(i),j,-1,0,0] for i,j in zip(vertex,weight)]

        ]
        """

        huffman_t = [[j,-1,-1,-1] for j in self.weight]

        '''
        所需两个辅助列表 vertex_t,weight_t
        以及一个权值最大值 max_weight
        '''

        'vertex需要将tensor格式list类型'
        vertex_t = self.vertex.numpy().tolist()



        '使用深拷贝，后续操作不影响原先weight列表'
        weight_t = copy.deepcopy(self.weight)

        '当临时保存的顶点集(元素为字符的ASCII码)，被访问后会变为0，当所有节点被访问，其list和为顶点集长度'
        while sum(vertex_t) != len(vertex_t):



            '获取下一个可访问的最小的节点'
            '将已访问的最小节点修改为不可访问,操作为:在顶点集为变为0，权值集为-1'
            sub_node_1_index = self.minweight(weight_t)
            vertex_t[sub_node_1_index] = 0
            weight_t[sub_node_1_index] = -1
            sub_node_2_index = self.minweight(weight_t)
            vertex_t[sub_node_2_index] = 0
            weight_t[sub_node_2_index] = -1

            '组成的子树，需要选择的该两个节点的parent为-1，即初始值'
            if huffman_t[sub_node_1_index][1] == -1 and huffman_t[sub_node_2_index][1] == -1:
                '新子树的组合权值'
                weight_s = self.weight[sub_node_2_index] + self.weight[sub_node_1_index]
                '霍夫曼树的最底层添加格式为[当前节点的权值，当前数组的父节点，最小节点二下标，最小节点一下标]'
                huffman_t.append( [ weight_s,  -1   ,sub_node_1_index,sub_node_2_index] )

                '在组成哈夫曼树时，将相应的子结点的父节点也更新'
                huffman_t[sub_node_1_index][1] = len(huffman_t)-1
                huffman_t[sub_node_2_index][1] = len(huffman_t)-1

                '将新组成的子树，其权值加入weight和其索引加入vertex'
                weight_t.append(weight_s)
                self.weight.append(weight_s)
                vertex_t.append(len(huffman_t))

        '最后将哈夫曼树头结点的父节点变0'
        huffman_t[len(huffman_t)-1][1] = 0
        return huffman_t

    '利用哈夫曼树进行编码'
    def encode(self):
        """
        构建临时辅助list，
        如哈夫曼树huffman，顶点集vertex，并获取左子树和右子树索引
        """

        huffman = np.array(copy.deepcopy(self.huffman_t))
        vertex = self.vertex.numpy().tolist()

        encode_vertex = {chr(a):'' for a in vertex}

        huffman_lchild = huffman[:,2].tolist()
        huffman_rchild = huffman[:,3].tolist()
        '外层循环是对每一个进行,c也就对应顶点集中的下标'
        for c in range(len(vertex)):
            temp_char = copy.deepcopy(c)
            '内层循环构建编码'
            for i in range(len(vertex),len(huffman)):
                '通过判断其是在该节点是在左子树还是右子数，来进行编码'
                if temp_char in huffman_lchild[len(vertex):]:
                    temp_char = huffman_lchild.index(temp_char)
                    encode_vertex[chr(vertex[c])] = '0'+encode_vertex[chr(vertex[c])]
                elif temp_char in huffman_rchild[len(vertex):]:
                    temp_char = huffman_rchild.index(temp_char)
                    encode_vertex[chr(vertex[c])] = '1'+encode_vertex[chr(vertex[c])]
                else:continue
        return encode_vertex

    '打印输入字符的编码'
    def print_encode(self):

        for i in self.contact:
            print(self.encode[chr(i)],end="")


```



## 图



### 图的遍历

无向图和有向图的区别在于构建的是邻接矩阵还是邻接表

邻接矩阵
$$
(G,E) =\left[ \begin{array}{c|cc} 
1 &2 &3\\
\hline
2 \\
3
\end{array} \right] 以G_v顶点为下标的邻接矩阵，若顶点间有邻边，则其元素为1
$$
邻接表
$$
(G,E)=
\left[\begin{array}{c}
1\\
2\\
3\\
\vdots\\
n
\end{array}
\right]
\begin{array}{c}
\rightarrow\\
\rightarrow\\
\rightarrow\\
\rightarrow\\
\rightarrow
\end{array}
\begin{array}{c}
[2,3,4\ldots]\\
[3,1\ldots]\\
[6\ldots]\\ 
\vdots\\
[n\ldots]
\end{array}
即邻接表是二维的matrix_{n\times n},它的下标就为对应的顶点，而它所属的一维的sub\_martix_{1\times n},保存邻居顶点
$$

#### 深度优先DFS:

即从某一节点，访问邻居顶点，（已访问的顶点无法被访问，即无法重复进入顶点序列）然后根据邻居顶点再访问下一顶点，当无可访问邻居顶点时，返回至这一深度遍历顶点序列的初始顶点，然后访问其下一个邻居，依次反复，直至所有顶点被包含就停止。、

```python
#无向图构建深度遍历
def DFS_graph(self,start_node):
    #遍历时已到达该节点，故其被标注不可访问
    self.vertex_list[start_node] = False
    #复制邻接矩阵
    adj_matrix = self.adj_matrix
    for i in range(len(adj_matrix[start_node])):
        if adj_matrix[start_node][i] != 0 and self.vertex_list[i] == True:
            self.path.append(i + 1)
            self.DFS_graph(i)
```

```python
# 有向图的深度遍历
def DFS_digraph(self,start_node):
    #遍历时已到达该节点，故其被标注不可访问
    self.vertex_list[start_node] = False
    #复制邻接表
    adj_table = self.adj_table
    for i in range(len(adj_table[start_node])):
        if  adj_table[start_node][i] != 0 and self.vertex_list[ adj_table[start_node][i] -1 ] == True:
            self.path.append(adj_table[start_node][i])
            self.DFS_digraph(adj_table[start_node][i]-1)
```

#### 广度优先BFS：

类似于树的层次遍历，利用一个顶点是否可访问的列表，从而控制输出顶点访问序列。由于是广度的，所以它是类似于层次性输出。

```python
    #无向图构建广度遍历
    def BFS_graph(self,start_node):
        #辅助list，保存的是顶点在数组中的索引位
        temp_adjnode = []
        #赋值邻接矩阵
        adj_matrix = self.adj_matrix
        #先将起始节点放入辅助list中
        temp_adjnode.append(start_node)
        #根据辅助list存储其广度遍历所需的访问形式：即输出list第一个元素，并即访问它的邻居存储在该list中，依次往复
        while len(temp_adjnode) != 0:
            count_1 = sum(adj_matrix[int(temp_adjnode[0])]) #判断该顶点是否有邻接顶点
            #判断当前顶点是否有邻居，以及其访问状态是否为真
            if count_1 != 0 and self.vertex_visited[temp_adjnode[0]] == True:
                self.path.append(temp_adjnode[0] + 1)
                #将当前访问顶点的可访问状态变为否
                self.vertex_visited[ temp_adjnode[0] ] = False
                # 将numpy.array转为list型
                temp = adj_matrix[temp_adjnode[0]].tolist()
                #与邻接表不同，邻接矩阵通过索引访问是否为邻居，然后保存索引位即可
                #将当前顶点所在行的邻接矩阵中，找到邻居，并将其加入辅助list
                temp_adjnode +=[i for i in range( len( temp ) ) if temp[i] != 0 ]
            temp_adjnode.pop(0)
```

```python
    #有向图广度遍历
    def BFS_digraph(self,start_node):
        #辅助list，保存的是顶点在数组中的索引位
        temp_adjnode = []
        adj_table = self.adj_table
        temp_adjnode.append(start_node)
        while len(temp_adjnode) != 0:
            #当搜索至该顶点，若其有邻居，且未被遍历过，则把邻居加入辅助list
            if adj_table[temp_adjnode[0]] != [] and self.vertex_visited[temp_adjnode[0]] == True:
                self.path.append(temp_adjnode[0] + 1)
                #因为是邻接表，其存储的是顶点值，而非存储时的索引位，所以在加入辅助list需要每一个顶点值减一，使其符合索引要求
                temp_adjnode +=[ i-1 for i in adj_table[temp_adjnode[0]]]
            #当搜索至该顶点，若没有邻居，且未被遍历过，则无需加入邻居
            elif adj_table[temp_adjnode[0]] == [] and self.vertex_visited[temp_adjnode[0]] == True:
                self.path.append(temp_adjnode[0] + 1)
                self.vertex_visited[temp_adjnode[0]] = False
            temp_adjnode.pop(0)
```

### Dijkstra单源路径搜索

```Python
import copy
import numpy as np

class Dijkstra:

    def __init__(self):
        """
        单源最短路径Dijkstra初始化:
        vertex : 存放结点 values--> string | shape[len(input)] 输入结点数
        aj_matrix : 邻接矩阵  values--> bool | shape[len(vertex),len(vertex)] 数组维度为结点数x结点数
        dist:对应顶点的最短路径长度 values --> int | shape[len(vertex)]
        S:存放V_0到v_i顶点已有最短路径 init_s = {V_0}
        T:存放剩余未有最短路径的顶点。
        path: 起始结点到目标结点的最短路径 values --> int | shape[len(vertex)]
        """

        '处理输入的顶点'
        input_vertex = input("请输入地名:间隔用空格\n")
        self.vertex = [i for i in input_vertex.split(" ")]
        self.vertex_dict = {chr(65+i) : self.vertex[i] for  i in range(len(self.vertex))}
        print( f"顶点:{self.vertex_dict}" )

        '处理输入的边'
        self.edge = []
        input_edge = input("请根据提示,输入每个地名之间距离的距离:如A B 200 输入0结束输入\n")
        while(input_edge != "0"):
            self.edge.append(input_edge.split())
            input_edge = input()
        '初始化邻接矩阵，其有边保存的是边的权重:-1为无穷'
        self.ad_matrix = np.negative(np.ones( ( len(self.vertex) , len(self.vertex) ) ,dtype=int),dtype=int)
        for i in self.edge:
            self.ad_matrix [ ord(i[0]) - 65 ][ ord(i[1]) - 65 ] = int(i[2])
            self.ad_matrix[ord(i[1]) - 65][ord(i[0]) - 65] = int(i[2])
        print(f"邻接矩阵:{self.ad_matrix}")
        '''
        邻接矩阵:[[ -1.  -1.  10.  -1.  30. 100.]
                 [ -1.  -1.   5.  -1.  -1.  -1.]
                 [ -1.  -1.  -1.  50.  -1.  -1.]
                 [ -1.  -1.  -1.  -1.  20.  10.]
                 [ -1.  -1.  -1.  -1.  -1.  60.]
                 [ -1.  -1.  -1.  -1.  -1.  -1.]]
        '''

        '需要注意的是，后续节点的使用都是int类型，而非str'
        '处理起点和终点'
        input_start_end=input("请输入起点和终点:用空格间隔\n")
        self.start = ord(input_start_end[0]) -65
        self.end = ord(input_start_end[-1]) -65

        '对应顶点的最短路径长度,初始化.'
        self.dist = self.ad_matrix[self.start]
        '''[ -1.  -1.  10.  -1.  30. 100.]'''

        '每个结点最短路径的前驱'
        ''' [0] '''
        self.search_path(self.dist)

    def search_path(self,dist):
        '''
        单源最小路径搜索
        '''
        '将邻接矩阵赋予一个同名变量中，保护原数据'
        ad_matrix = copy.deepcopy(self.ad_matrix)
        ad_matrix = ad_matrix.tolist()
        dist = dist.tolist()
        '初始化最小值mins，中间结点u，'
        mins,i,u,j=0,0,0,0

        '初始化S：用于记录已有最短路径结点'
        S = []
        S.append(self.start)
        '剩余未最找到最短路径结点'
        T = [(ord(i)-65) for i in self.vertex_dict.keys() if (ord(i) -65)  != S[0]]

        '使用列表生成，将path进行初始化'
        path = [   self.start  if ad_matrix[self.start][i] != -1 else -1 for i in range(len( ad_matrix[self.start] ))  ]

        '将剩余结点进行访问'
        for j in range(len(T)):
            mins = 65534
            '找未最短路径的结点'
            for i in dist:
                '搜索T中最短路径结点，赋为mins，将其加入S,并在T中移去'
                #i为最短路径
                if i != -1 and dist.index(i) not in S and i < mins:
                    mins = i
            u = dist.index(mins)
            S.append(u)
            T.pop(T.index(u))

            '在T中，找剩余未最短路径结点，与中间结点u是否有路径，且路径长度是否最短，若最短，则进行修改。否则不动'
            for num  in  T :
                if num not in S:
                    if ad_matrix[u][num] != -1 and  dist[u]+ad_matrix[u][num] < dist [num]  or   dist[num] == -1:
                        dist[num] = dist[u]+ad_matrix[u][num]
                        path[num] = u
        return path,dist

    def display(self,path,dist):
        '''
        最小路径展示
        '''
        start = self.start
        end = self.end
        display_path = []
        '将最短路径结点加入打印list中'
        while end != start:
            display_path.insert(0,end)
            end = path[end]
        display_path.insert(0,start)
        '打印字母型路径'
        for i in display_path[:len(display_path)-1]:
            print(chr(i+65),end = "-->")
        print(chr(display_path[len(display_path)-1]+65))
        '打印顶点集'
        print(self.vertex_dict)
        '打印文字型'
        for i in display_path[:len(display_path)-1]:
            print(self.vertex_dict[chr(i+65)],end = "-->")
        print( self.vertex_dict[chr(display_path[len(display_path)-1]+65)] )
        '输出起点到终点的最短路径'
        print(f"{self.vertex_dict[chr(self.start+65)]}到{self.vertex_dict[chr(self.end+65)]}距离最短为:{dist[self.end]}米")
```

