import 'package:flutter_riverpod/flutter_riverpod.dart';

class Pedido {
  final String name;
  final double basePrice;
  int quantity;

  Pedido({required this.name, required this.basePrice, required this.quantity});
  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}

class PedidosNotifier extends StateNotifier<List<Pedido>> {
  PedidosNotifier() : super([]);

  void addPedido(Pedido pedido) {
    final index = state.indexWhere((p) => p.name == pedido.name);
    if (index != -1) {
      state[index].quantity += pedido.quantity;
      state = List.from(state);
    } else {
      state = [...state, pedido];
    }
  }

  void clearPedidos() {
    state = [];
  }

  void removePedido(Pedido pedido) {
    state = state.where((p) => p != pedido).toList();
  }

  void incrementQuantity(Pedido pedido) {
    final index = state.indexWhere((p) => p.name == pedido.name);
    if (index != -1) {
      state[index].incrementQuantity();
      state = List.from(state);
    }
  }

  void decrementQuantity(Pedido pedido) {
    final index = state.indexWhere((p) => p.name == pedido.name);
    if (index != -1) {
      state[index].decrementQuantity();
      state = List.from(state); 
    }
  }
}

final pedidosProvider =
    StateNotifierProvider<PedidosNotifier, List<Pedido>>((ref) {
  return PedidosNotifier();
});
