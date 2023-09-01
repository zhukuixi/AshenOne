#104. Maximum Depth of Binary Tree

# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    # iterative
    def maxDepth(self, root: Optional[TreeNode]) -> int:
        if not root:
            return 0       
        num_node_level = 1
        level = 1
        stack = [root]
        while stack:
            node = stack.pop(0)
            if node.left:
                stack.append(node.left)             
            if node.right :
                stack.append(node.right)              
            num_node_level -= 1

            if num_node_level == 0 and len(stack)>0:
                level += 1
                num_node_level = len(stack)

        return level
    
    # recursive
            
            d


            


    