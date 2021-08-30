import 'package:dartserverstarter/utils/controller.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf/shelf.dart';

class BlogController extends WebController {
  @override
  Router registerRoute() {
    router.get('/', listBlogs);
    router.post('/add/', addBlog);
    router.patch('/update/<id>/', updateBlog);
    router.delete('/delete/<id>/', deleteBlog);
    return super.registerRoute();
  }

  Future<Response> listBlogs(Request request) async {
    return Response.ok('body');
  }

  Future<Response> addBlog(Request request) async {
    return Response.ok('body');
  }

  Future<Response> updateBlog(Request request, String id) async {
    return Response.ok('');
  }

  Future<Response> deleteBlog(Request request, String id) async {
    return Response.ok('');
  }
}
