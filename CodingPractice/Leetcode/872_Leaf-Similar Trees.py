# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def leafSimilar(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> bool:
        return self.getBottomLeaf(root1)==self.getBottomLeaf(root2)
        
    
    def getBottomLeaf(self,root):
        stack = [root]
        result = []
        while stack:
            node = stack.pop()     
            if node.right==None and node.left==None:
                result.append(node.val)                
            if node.right:
                stack.append(node.right)
            if node.left:
                stack.append(node.left)
        return result