



Spring MVC是Spring提供的一个强大而灵活的web框架，基于Java的实现了MVC设计模式

Spring MVC主要由DispatcherServlet、处理器映射、处理器(控制器)、视图解析器、视图组成。通过将web层进行职责解耦，把复杂的web应用分成逻辑清晰的几部分，简化开发，减少出错，方便组内开发人员之间的配合。



# SpringMVC工作原理

1. 客户端提交请求 -> DispatcherServlet：客户端请求发送到前端控制器，但前端控制自身不处理请求
2. DispatcherServlet -> HandlerMapping：前端控制器将请求调用处理器映射器进行解析，并将对象返给前端控制器；
3. DispatcherServlet -> HandlerAdapter：前端控制器将请求调用处理器适配器
4. HandlerAdapter -> Controller：处理器适配器去执行Controller并得到ModelAndView(数据和视图)，并层层返回给前端控制器
5. DispatcherServlet -> ViewResolver：前端控制器调用视图解析器对 ModelAndView 进行解析为具体的View；
6. View -> 渲染，View会根据传进来的Model模型数据进行渲染，此处的Model实际是一个Map数据结构；
7. DispatcherServlet返回响应给客户端



# SpringMVC核心组件

**DispatcherServlet**

前端控制器，是整个Spring MVC的核心，负责接收HTTP请求组织协调Spring MVC的各个组成部分，DispatcherServlet的存在降低了组件之间的耦合性。

**HandlerMapping**

映射处理器，负责根据用户请求找到Handler即处理器，Spring MVC 提供了不同的映射器实现不同的映射方式，例如：配置文件方式，实现接口方式，注解方式等。

**HandlAdapter**

处理适配器，通过HandlerAdapter对处理器进行执行，这是适配器模式的应用，通过扩展适配器可以对更多类型的处理器进行执行。

**Handler**

Handler是继DispatcherServlet前端控制器的后端控制器，在DispatcherServlet的控制下Handler对具体的用户请求进行处理。

**ViewResolver**

ViewResolver负责将处理结果生成View视图，ViewResolver首先根据逻辑视图名解析成物理视图名即具体的页面地址，再生成View视图对象，最后对View进行渲染将处理结果通过页面展示给用户。

**View**

SpringMVC框架提供了很多的View视图类型的支持，包括：jstlView、freemarkerView、pdfView等。我们最常用的视图就是jsp。



# SpringMVC和Struts2 区别

* 拦截机制：Struts2 是类级别拦截，SpringMVC是方法级别的拦截。
* 底层框架：Struts2 是采用过滤器实现的filter，springmvc 采用 servlet 实现的
* 性能方面：Struts2 每次请求都会实例化一个Action；SpringMVC的Controller Bean默认单例模式
* 配置方面：spring MVC和Spring是无缝的。从这个项目的管理和安全上也比Struts2高。



# SpringMVC重定向和转发

转发：在返回值前面加"forward:"，譬如"forward:user.do?name=method4"

重定向：在返回值前面加"redirect:"，譬如"redirect:http://www.baidu.com"