# Definition for a binary tree node.
# class TreeNode:
#     def __init__(self, val=0, left=None, right=None):
#         self.val = val
#         self.left = left
#         self.right = right
class Solution:
    def goodNodes(self, root: TreeNode) -> int:
        stack = [(root,root.val)]
        result = 1
        while stack:
            node,node_val = stack.pop()
            if node.left:
                stack.append((node.left,max(node.left.val,node_val)))
                if node_val <= node.left.val:
                    result += 1
            if node.right:
                stack.append((node.right,max(node.right.val,node_val)))
                if node_val <= node.right.val:
                    result += 1

        return result








        