# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def pathSum(self, root: Optional[TreeNode], targetSum: int) -> List[List[int]]:
        
        def dfs(root,s,store):           
            if not root:
                return 

            store.append(root.val)
            
            if root.val == s and root.left is None and root.right is None:                
                answer.append(list(store))
            dfs(root.left,s-root.val,store)           
            dfs(root.right,s-root.val,store)
            store.pop()

        answer = []
        store = []
        dfs(root,targetSum,store)
        return answer


		
        