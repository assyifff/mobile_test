import 'package:flutter/material.dart';
import 'package:mobile_test/ui/util/color.dart';
import 'package:mobile_test/ui/view_model/user_provider.dart';
import 'package:provider/provider.dart';

class ThirdScreen extends StatefulWidget {
  final String selectedTitle;
  const ThirdScreen({Key? key, required this.selectedTitle}) : super(key: key);

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  late ScrollController _scrollController;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _userProvider = Provider.of<UserProvider>(context, listen: false);
    _userProvider.initialize(page: 1, perPage: 10);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (!_userProvider.isLoading &&
        !_userProvider.isError &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
      _userProvider.loadNextPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Third Screen',
          style: TextStyle(color: appBarText),
        ),
        backgroundColor: buttonText,
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: appBarText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<UserProvider>(
          builder: (context, provider, child) {
            return RefreshIndicator(
              onRefresh: () => provider.refreshData(),
              child: ListView.separated(
                controller: _scrollController,
                itemCount: provider.userList.length + 1,
                itemBuilder: (context, index) {
                  if (index < provider.userList.length) {
                    final user = provider.userList[index];
                    return InkWell(
                      onTap: () async {
                        Navigator.pop(
                          context,
                          '${user.firstName} ${user.lastName}',
                        );
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user.avatar.toString(),
                          ),
                        ),
                        title: Text(
                          '${user.firstName.toString()} ${user.lastName.toString()}',
                        ),
                        subtitle: Text(user.email.toString()),
                      ),
                    );
                  } else if (provider.isLoading) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                          ],
                        ),
                      ),
                    );
                  } else if (provider.isError) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Error occurred. Please try again.'),
                        ],
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                },
                separatorBuilder: (context, index) {
                  return const Divider();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
