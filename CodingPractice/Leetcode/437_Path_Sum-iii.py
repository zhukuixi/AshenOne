# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    cnt = 0 
    targetSum = None
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> int:
        self.targetSum = targetSum
        self.dfs(root,targetSum,True)
        return self.cnt

    def dfs(self,root,s,isRoot):
        if not root:
            return 

        if root.val == s:
            self.cnt += 1
        # continue
        self.dfs(root.left,s-root.val,False)
        self.dfs(root.right,s-root.val,False)
        if isRoot:
            self.dfs(root.left,self.targetSum,True)
            self.dfs(root.right,self.targetSum,True)
        

        