# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    
    def hasPathSum(self, root: Optional[TreeNode], targetSum: int) -> bool:
        def dfs(root, s):            
            if root is None:
                return False
            if s-root.val == 0 and root.left is None and root.right is None:
                return True
           
            return dfs(root.left,s - root.val) or dfs(root.right,s - root.val)

       
        return dfs(root,targetSum)
       
            
