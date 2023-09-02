# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def rightSideView(self, root: Optional[TreeNode]) -> List[int]:
        if not root:
            return 
            
        result = []     
        queue = []
        queue.append(root)
        next_queue = []

        while queue:
            node = queue.pop(0)
      
            if node.left:
                next_queue.append(node.left)              
            if node.right:
                next_queue.append(node.right)

            if len(queue) == 0:                    
                result.append(node.val)
                queue = next_queue
                next_queue = []


        return result

        