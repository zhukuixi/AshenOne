# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def maxLevelSum(self, root: Optional[TreeNode]) -> int:
        queue = [root]
        next_level = []

        level = 0
        level_sum = 0

        max_level = 1
        max_sum = float('-inf')

        while queue:
            node = queue.pop(0)
            level_sum += node.val
            
            if node.left:
                next_level.append(node.left)                
            if node.right:
                next_level.append(node.right)

            if len(queue) == 0:
                level += 1
                if level_sum > max_sum:
                    max_sum = level_sum 
                    max_level = level
                queue = next_level
                next_level = []
                level_sum = 0
            
               

     
        return max_level

                



        

        