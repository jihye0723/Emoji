package com.o2a4.chattcp.util;

import java.util.*;
/**
 */
public class AhoCorasick {
    private Boolean failureStatesConstructed = false;
    private Node root;
    public AhoCorasick() {
        this.root = new Node(true);
    }

    public void addKeyword(String keyword) {
        if (keyword == null || keyword.length() == 0) {
            return;
        }
        Node currentState = this.root;
        for (Character character : keyword.toCharArray()) {
            currentState = currentState.insert(character);
        }
        currentState.addEmit(keyword);
    }

    public Collection<Emit> parseText(String text) {
        checkForConstructedFailureStates();
        Node currentState = this.root;
        List<Emit> collectedEmits = new ArrayList<>();
        for (int position = 0; position < text.length(); position++) {
            Character character = text.charAt(position);
            currentState = currentState.nextState(character);
            Collection<String> emits = currentState.emit();
            if (emits == null || emits.isEmpty()) {
                continue;
            }
            for (String emit : emits) {
                collectedEmits.add(new Emit(position - emit.length() + 1, position, emit));
            }
        }
        return collectedEmits;
    }

    private void checkForConstructedFailureStates() {
        if (!this.failureStatesConstructed) {
            constructFailureStates();
        }
    }

    private void constructFailureStates() {
        Queue<Node> queue = new LinkedList<>();
        for (Node depthOneState : this.root.children()) {
            depthOneState.setFailure(this.root);
            queue.add(depthOneState);
        }
        this.failureStatesConstructed = true;
        while (!queue.isEmpty()) {
            Node parentNode = queue.poll();
            for (Character transition : parentNode.getTransitions()) {
                Node childNode = parentNode.find(transition);
                queue.add(childNode);
                Node failNode = parentNode.getFailure().nextState(transition);
                childNode.setFailure(failNode);
                childNode.addEmit(failNode.emit());
            }
        }
    }
    private static class Node{
        private Map<Character, Node> map;
        private List<String> emits;
        private Node failure;
        private Boolean isRoot = false;
        public Node(){
            map = new HashMap<>();
            emits = new ArrayList<>();
        }
        public Node(Boolean isRoot) {
            this();
            this.isRoot = isRoot;
        }
        public Node insert(Character character) {
            Node node = this.map.get(character);
            if (node == null) {
                node = new Node();
                map.put(character, node);
            }
            return node;
        }
        public void addEmit(String keyword) {
            emits.add(keyword);
        }
        public void addEmit(Collection<String> keywords) {
            emits.addAll(keywords);
        }

        public Node find(Character character) {
            return map.get(character);
        }

        private Node nextState(Character transition) {
            Node state = this.find(transition);
            if (state != null) {
                return state;
            }
            if (this.isRoot) {
                return this;
            }
            return this.failure.nextState(transition);
        }
        public Collection<Node> children() {
            return this.map.values();
        }
        public void setFailure(Node node) {
            failure = node;
        }
        public Node getFailure() {
            return failure;
        }
        public Set<Character> getTransitions() {
            return map.keySet();
        }
        public Collection<String> emit() {
            return this.emits == null ? Collections.<String>emptyList() : this.emits;
        }
    }
    public static class Emit{
        private final String keyword;
        private final int start;
        private final int end;
        public Emit(final int start, final int end, final String keyword) {
            this.start = start;
            this.end = end;
            this.keyword = keyword;
        }
        public String getKeyword() {
            return this.keyword;
        }

        public int getStart() {
            return this.start;
        }

        public int getEnd() {
            return end;
        }

        @Override
        public String toString() {
            return super.toString() + "=" + this.keyword;
        }
    }
}
