# Barravar helm-charts repository

This repository hosts Helm charts customized to Barravar.

[Helm](https://helm.sh) must be installed to use the charts. Refer to Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, run the following command to add the repo:

```
helm repo add barravar https://barravar.github.io/helm-charts
```

Run the command below to retrieve the latest versions of the packages available:

```
helm repo update
```

To install a chart:

```
helm install <release-name> barravar/<chart-name>
```

To uninstall a chart:

```
helm delete <release-name>
```

Happy Helming!
