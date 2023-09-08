# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def leafSimilar(self, root1: Optional[TreeNode], root2: Optional[TreeNode]) -> bool:
        def readBottom(root):        
            if not root:
                return []   
            if root.left == root.right == None:
                return [root.val]            
            return readBottom(root.left) +readBottom(root.right)

        def readBottom1(root):
            stack = [root]
            result = []
            while stack:
                node = stack.pop()
                if node.left==None and node.right==None:
                    result.append(node.val)
                if node.left:
                    stack.append(node.left)
                if node.right:
                    stack.append(node.right)
            return result

        l1 = readBottom1(root1)
        l2 = readBottom1(root2)
       
        
        return l1==l2
        

           
        