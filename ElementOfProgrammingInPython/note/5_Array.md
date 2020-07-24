# Chapter 5：Array

## 打基础
* B=A是指向 B=list(A)是shallow copy.
* B=copy.copy(A) #shallow copy!创建B时，对于list中非primitive type，提供了相同的指向。所以随后B,A两者之一修改了非primitive type元素的内容，另外的也会被修改。如果修改了非primitive那个元素的指向本身，则另外一者不受影响.
* B=copy.deepcopy(A) #deepcopy!创建B时，对于list中非primitive type，创建了相同内容的新指向。
* bisect.bisect(A,6) A是从小到大sorted array，该函数返还6这个元素若要安插进去，应该在A哪个index.(如果是有多个可安插位置，返回最右边的index）  
* bisect.bisect_left(A,6) 返回最左边的合适安插index
* bisect.bisect_right(A,6) 返回最右边的合适安插index
* A.reverse()  [in-place] 反转list
* reversed(A)  [returns an iterator)
* A.sort()     [in-place]
* sorted(A)    [returns a shallow copy]
* del A[i] [deletes the i-th element]
* del A[i:j] [deletes elements whose index within [i,j)]
* 对i-th index进行元素删除或者插入，计算复杂度为O(n-i).n为array修改前长度

* 用Slicing  
#	
	B=A[:] 代表shallow copy
	A[::-1] reverses list
    A[i:j:k] 注意负数,比如-3是代表倒数第三个.i为起点index,j为终点index(不包含）,k为index变化的步数，默认为1.

* List comprehension [以及reduce,map,filter]
#
	# Example of reduce
	>A=[1,2,3,4]
	>functools.reduce(lambda e,c:c+e,A,100)

	# Example of map
	>items = [1, 2, 3, 4, 5]
	>squared = list(map(lambda x: x**2, items))
	
	# Example of filter 
    # The filter resembles a for loop but it is a builtin function and faster.
	>number_list = range(-5, 5)
	>less_than_zero = list(filter(lambda x: x < 0, number_list))

* Dictionary Comprehension  
  Dict comprehension is defined with a similar syntax as list comprehension, but with a key:value pair with curly
  bracket in expression.   {key:value for e in A}
#
	# dict comprehension example to reverse key:value pair in a dictionary
	>f_dict = {f:i for i,f in enumerate(fruits)}
	>f_dict
	{'apple': 0, 'banana': 2, 'cherry': 3, 'mango': 1}
	# dict comprehension to reverse key:value pair in a dictionary
	>{v:k for k,v in f_dict.items()}
	{0: 'apple', 1: 'mango', 2: 'banana', 3: 'cherry'}

    
* Set Comprehension
#
	{s for s in [1, 2, 1, 0]}
### 5.0 even_odd.py
2个控制边界的indx_pointer,定义了三个区域  
joo Close Boundary Explorer Style!
### 5.1 dutch_national_flag.py  

*背景知识 **Quicksort**
#
	# Python program for implementation of Quicksort Sort 
	  
	# This function takes last element as pivot, places 
	# the pivot element at its correct position in sorted 
	# array, and places all smaller (smaller than pivot) 
	# to left of pivot and all greater elements to right 
	# of pivot 
	def partition(arr,low,high): 
	    i = ( low-1 )         # index of smaller element 
	    pivot = arr[high]     # pivot 
	  
	    for j in range(low , high): 
	  
	        # If current element is smaller than the pivot 
	        if   arr[j] < pivot: 
	          
	            # increment index of smaller element 
	            i = i+1 
	            arr[i],arr[j] = arr[j],arr[i] 
	  
	    arr[i+1],arr[high] = arr[high],arr[i+1] 
	    return ( i+1 ) 
	  
	# The main function that implements QuickSort 
	# arr[] --> Array to be sorted, 
	# low  --> Starting index, 
	# high  --> Ending index 
	  
	# Function to do Quick sort 
	def quickSort(arr,low,high): 
	    if low < high: 
	  
	        # pi is partitioning index, arr[p] is now 
	        # at right place 
	        pi = partition(arr,low,high) 
	  
	        # Separately sort elements before 
	        # partition and after partition 
	        quickSort(arr, low, pi-1) 
	        quickSort(arr, pi+1, high) 
	  

### 5.2 int_as_array_increment.py 
用array来模拟加法

### 5.3 int_as_array_multiply.py 
用array来模拟乘法[**有难点**！]  
#
* 结果长度和输入2数组长度的关系 M<=X+Y，所以总长度设置为X+Y,再去除leading zero.
* 结果填写位置ind_fill和输入ind_i,ind_j的关系 （ind_fill = ind_i+ind_j+1）  
#
	ans[i+j+1] += num1[i]  * num2[j] 
	ans[i+j] += ans[i+j+1] // 10
    ans[i+j+1] %= 10

