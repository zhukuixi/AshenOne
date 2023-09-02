# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    
    def longestZigZag(self, root: Optional[TreeNode]) -> int:
        self.cnt = 0
        def dfs(root,s,direction):
            self.cnt = max(self.cnt,s)
            if root.left is not None:
                dfs(root.left,s+1,'left') if direction!='left' else dfs(root.left,1,'')
            if root.right is not None:
                dfs(root.right,s+1,'right') if direction!='right' else dfs(root.right,1,'')    
 
        
        dfs(root,0,'')
        return self.cnt
