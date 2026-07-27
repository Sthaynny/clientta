import 'package:flutter/material.dart';
import 'package:university_hub/core/router/hub_route_observer.dart';

/// Recarrega dados quando a rota volta a ficar visível (ex.: após fechar formulário).
mixin HubRouteRefreshMixin<T extends StatefulWidget> on State<T>, RouteAware {
  void onHubRouteVisible();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute<void>) {
      hubRouteObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    hubRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() => onHubRouteVisible();
}
